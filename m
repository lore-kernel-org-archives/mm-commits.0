From: akpm@linux-foundation.org
Subject: - pxafb-un-nest-pxafb_parse_options-to-cleanup-the-coding-style-issue.patch removed from -mm tree
Date: Thu, 01 May 2008 02:25:00 -0700
Message-ID: <200805010925.m419P03C030154@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49457 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755286AbYEAJZn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:25:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eric.miao@marvell.com, adaplas@pol.net, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     pxafb: un-nest pxafb_parse_options() to cleanup the coding style issue
has been removed from the -mm tree.  Its filename was
     pxafb-un-nest-pxafb_parse_options-to-cleanup-the-coding-style-issue.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pxafb: un-nest pxafb_parse_options() to cleanup the coding style issue
From: eric miao <eric.miao@marvell.com>

pxafb_parse_options() has very long lines exceeding far beyond 80 characters,
which makes the function looks bad.  Un-nest it into smaller functions and use
a temporary string for only what has been overridden instead of the whole
dev_info() message to reduce the line a bit more.

Signed-off-by: eric miao <eric.miao@marvell.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/pxafb.c |  306 +++++++++++++++++++++-------------------
 1 file changed, 166 insertions(+), 140 deletions(-)

diff -puN drivers/video/pxafb.c~pxafb-un-nest-pxafb_parse_options-to-cleanup-the-coding-style-issue drivers/video/pxafb.c
--- a/drivers/video/pxafb.c~pxafb-un-nest-pxafb_parse_options-to-cleanup-the-coding-style-issue
+++ a/drivers/video/pxafb.c
@@ -1211,154 +1211,180 @@ static struct pxafb_info * __init pxafb_
 }
 
 #ifdef CONFIG_FB_PXA_PARAMETERS
-static int __init pxafb_parse_options(struct device *dev, char *options)
+static int parse_opt_mode(struct device *dev, const char *this_opt)
 {
 	struct pxafb_mach_info *inf = dev->platform_data;
-	char *this_opt;
 
-        if (!options || !*options)
-                return 0;
+	const char *name = this_opt+5;
+	unsigned int namelen = strlen(name);
+	int res_specified = 0, bpp_specified = 0;
+	unsigned int xres = 0, yres = 0, bpp = 0;
+	int yres_specified = 0;
+	int i;
+	for (i = namelen-1; i >= 0; i--) {
+		switch (name[i]) {
+		case '-':
+			namelen = i;
+			if (!bpp_specified && !yres_specified) {
+				bpp = simple_strtoul(&name[i+1], NULL, 0);
+				bpp_specified = 1;
+			} else
+				goto done;
+			break;
+		case 'x':
+			if (!yres_specified) {
+				yres = simple_strtoul(&name[i+1], NULL, 0);
+				yres_specified = 1;
+			} else
+				goto done;
+			break;
+		case '0' ... '9':
+			break;
+		default:
+			goto done;
+		}
+	}
+	if (i < 0 && yres_specified) {
+		xres = simple_strtoul(name, NULL, 0);
+		res_specified = 1;
+	}
+done:
+	if (res_specified) {
+		dev_info(dev, "overriding resolution: %dx%d\n", xres, yres);
+		inf->modes[0].xres = xres; inf->modes[0].yres = yres;
+	}
+	if (bpp_specified)
+		switch (bpp) {
+		case 1:
+		case 2:
+		case 4:
+		case 8:
+		case 16:
+			inf->modes[0].bpp = bpp;
+			dev_info(dev, "overriding bit depth: %d\n", bpp);
+			break;
+		default:
+			dev_err(dev, "Depth %d is not valid\n", bpp);
+			return -EINVAL;
+		}
+	return 0;
+}
+
+static int parse_opt(struct device *dev, char *this_opt)
+{
+	struct pxafb_mach_info *inf = dev->platform_data;
+	struct pxafb_mode_info *mode = &inf->modes[0];
+	char s[64];
 
-	dev_dbg(dev, "options are \"%s\"\n", options ? options : "null");
+	s[0] = '\0';
 
-	/* could be made table driven or similar?... */
-        while ((this_opt = strsep(&options, ",")) != NULL) {
-                if (!strncmp(this_opt, "mode:", 5)) {
-			const char *name = this_opt+5;
-			unsigned int namelen = strlen(name);
-			int res_specified = 0, bpp_specified = 0;
-			unsigned int xres = 0, yres = 0, bpp = 0;
-			int yres_specified = 0;
-			int i;
-			for (i = namelen-1; i >= 0; i--) {
-				switch (name[i]) {
-				case '-':
-					namelen = i;
-					if (!bpp_specified && !yres_specified) {
-						bpp = simple_strtoul(&name[i+1], NULL, 0);
-						bpp_specified = 1;
-					} else
-						goto done;
-					break;
-				case 'x':
-					if (!yres_specified) {
-						yres = simple_strtoul(&name[i+1], NULL, 0);
-						yres_specified = 1;
-					} else
-						goto done;
-					break;
-				case '0' ... '9':
-					break;
-				default:
-					goto done;
-				}
-			}
-			if (i < 0 && yres_specified) {
-				xres = simple_strtoul(name, NULL, 0);
-				res_specified = 1;
-			}
-		done:
-			if (res_specified) {
-				dev_info(dev, "overriding resolution: %dx%d\n", xres, yres);
-				inf->modes[0].xres = xres; inf->modes[0].yres = yres;
-			}
-			if (bpp_specified)
-				switch (bpp) {
-				case 1:
-				case 2:
-				case 4:
-				case 8:
-				case 16:
-					inf->modes[0].bpp = bpp;
-					dev_info(dev, "overriding bit depth: %d\n", bpp);
-					break;
-				default:
-					dev_err(dev, "Depth %d is not valid\n", bpp);
-				}
-                } else if (!strncmp(this_opt, "pixclock:", 9)) {
-                        inf->modes[0].pixclock = simple_strtoul(this_opt+9, NULL, 0);
-			dev_info(dev, "override pixclock: %ld\n", inf->modes[0].pixclock);
-                } else if (!strncmp(this_opt, "left:", 5)) {
-                        inf->modes[0].left_margin = simple_strtoul(this_opt+5, NULL, 0);
-			dev_info(dev, "override left: %u\n", inf->modes[0].left_margin);
-                } else if (!strncmp(this_opt, "right:", 6)) {
-                        inf->modes[0].right_margin = simple_strtoul(this_opt+6, NULL, 0);
-			dev_info(dev, "override right: %u\n", inf->modes[0].right_margin);
-                } else if (!strncmp(this_opt, "upper:", 6)) {
-                        inf->modes[0].upper_margin = simple_strtoul(this_opt+6, NULL, 0);
-			dev_info(dev, "override upper: %u\n", inf->modes[0].upper_margin);
-                } else if (!strncmp(this_opt, "lower:", 6)) {
-                        inf->modes[0].lower_margin = simple_strtoul(this_opt+6, NULL, 0);
-			dev_info(dev, "override lower: %u\n", inf->modes[0].lower_margin);
-                } else if (!strncmp(this_opt, "hsynclen:", 9)) {
-                        inf->modes[0].hsync_len = simple_strtoul(this_opt+9, NULL, 0);
-			dev_info(dev, "override hsynclen: %u\n", inf->modes[0].hsync_len);
-                } else if (!strncmp(this_opt, "vsynclen:", 9)) {
-                        inf->modes[0].vsync_len = simple_strtoul(this_opt+9, NULL, 0);
-			dev_info(dev, "override vsynclen: %u\n", inf->modes[0].vsync_len);
-                } else if (!strncmp(this_opt, "hsync:", 6)) {
-                        if (simple_strtoul(this_opt+6, NULL, 0) == 0) {
-				dev_info(dev, "override hsync: Active Low\n");
-				inf->modes[0].sync &= ~FB_SYNC_HOR_HIGH_ACT;
-			} else {
-				dev_info(dev, "override hsync: Active High\n");
-				inf->modes[0].sync |= FB_SYNC_HOR_HIGH_ACT;
-			}
-                } else if (!strncmp(this_opt, "vsync:", 6)) {
-                        if (simple_strtoul(this_opt+6, NULL, 0) == 0) {
-				dev_info(dev, "override vsync: Active Low\n");
-				inf->modes[0].sync &= ~FB_SYNC_VERT_HIGH_ACT;
-			} else {
-				dev_info(dev, "override vsync: Active High\n");
-				inf->modes[0].sync |= FB_SYNC_VERT_HIGH_ACT;
-			}
-                } else if (!strncmp(this_opt, "dpc:", 4)) {
-                        if (simple_strtoul(this_opt+4, NULL, 0) == 0) {
-				dev_info(dev, "override double pixel clock: false\n");
-				inf->lccr3 &= ~LCCR3_DPC;
-			} else {
-				dev_info(dev, "override double pixel clock: true\n");
-				inf->lccr3 |= LCCR3_DPC;
-			}
-                } else if (!strncmp(this_opt, "outputen:", 9)) {
-                        if (simple_strtoul(this_opt+9, NULL, 0) == 0) {
-				dev_info(dev, "override output enable: active low\n");
-				inf->lccr3 = (inf->lccr3 & ~LCCR3_OEP) | LCCR3_OutEnL;
-			} else {
-				dev_info(dev, "override output enable: active high\n");
-				inf->lccr3 = (inf->lccr3 & ~LCCR3_OEP) | LCCR3_OutEnH;
-			}
-                } else if (!strncmp(this_opt, "pixclockpol:", 12)) {
-                        if (simple_strtoul(this_opt+12, NULL, 0) == 0) {
-				dev_info(dev, "override pixel clock polarity: falling edge\n");
-				inf->lccr3 = (inf->lccr3 & ~LCCR3_PCP) | LCCR3_PixFlEdg;
-			} else {
-				dev_info(dev, "override pixel clock polarity: rising edge\n");
-				inf->lccr3 = (inf->lccr3 & ~LCCR3_PCP) | LCCR3_PixRsEdg;
-			}
-                } else if (!strncmp(this_opt, "color", 5)) {
-			inf->lccr0 = (inf->lccr0 & ~LCCR0_CMS) | LCCR0_Color;
-                } else if (!strncmp(this_opt, "mono", 4)) {
-			inf->lccr0 = (inf->lccr0 & ~LCCR0_CMS) | LCCR0_Mono;
-                } else if (!strncmp(this_opt, "active", 6)) {
-			inf->lccr0 = (inf->lccr0 & ~LCCR0_PAS) | LCCR0_Act;
-                } else if (!strncmp(this_opt, "passive", 7)) {
-			inf->lccr0 = (inf->lccr0 & ~LCCR0_PAS) | LCCR0_Pas;
-                } else if (!strncmp(this_opt, "single", 6)) {
-			inf->lccr0 = (inf->lccr0 & ~LCCR0_SDS) | LCCR0_Sngl;
-                } else if (!strncmp(this_opt, "dual", 4)) {
-			inf->lccr0 = (inf->lccr0 & ~LCCR0_SDS) | LCCR0_Dual;
-                } else if (!strncmp(this_opt, "4pix", 4)) {
-			inf->lccr0 = (inf->lccr0 & ~LCCR0_DPD) | LCCR0_4PixMono;
-                } else if (!strncmp(this_opt, "8pix", 4)) {
-			inf->lccr0 = (inf->lccr0 & ~LCCR0_DPD) | LCCR0_8PixMono;
+	if (!strncmp(this_opt, "mode:", 5)) {
+		return parse_opt_mode(dev, this_opt);
+	} else if (!strncmp(this_opt, "pixclock:", 9)) {
+		mode->pixclock = simple_strtoul(this_opt+9, NULL, 0);
+		sprintf(s, "pixclock: %ld\n", mode->pixclock);
+	} else if (!strncmp(this_opt, "left:", 5)) {
+		mode->left_margin = simple_strtoul(this_opt+5, NULL, 0);
+		sprintf(s, "left: %u\n", mode->left_margin);
+	} else if (!strncmp(this_opt, "right:", 6)) {
+		mode->right_margin = simple_strtoul(this_opt+6, NULL, 0);
+		sprintf(s, "right: %u\n", mode->right_margin);
+	} else if (!strncmp(this_opt, "upper:", 6)) {
+		mode->upper_margin = simple_strtoul(this_opt+6, NULL, 0);
+		sprintf(s, "upper: %u\n", mode->upper_margin);
+	} else if (!strncmp(this_opt, "lower:", 6)) {
+		mode->lower_margin = simple_strtoul(this_opt+6, NULL, 0);
+		sprintf(s, "lower: %u\n", mode->lower_margin);
+	} else if (!strncmp(this_opt, "hsynclen:", 9)) {
+		mode->hsync_len = simple_strtoul(this_opt+9, NULL, 0);
+		sprintf(s, "hsynclen: %u\n", mode->hsync_len);
+	} else if (!strncmp(this_opt, "vsynclen:", 9)) {
+		mode->vsync_len = simple_strtoul(this_opt+9, NULL, 0);
+		sprintf(s, "vsynclen: %u\n", mode->vsync_len);
+	} else if (!strncmp(this_opt, "hsync:", 6)) {
+		if (simple_strtoul(this_opt+6, NULL, 0) == 0) {
+			sprintf(s, "hsync: Active Low\n");
+			mode->sync &= ~FB_SYNC_HOR_HIGH_ACT;
 		} else {
-			dev_err(dev, "unknown option: %s\n", this_opt);
-			return -EINVAL;
+			sprintf(s, "hsync: Active High\n");
+			mode->sync |= FB_SYNC_HOR_HIGH_ACT;
+		}
+	} else if (!strncmp(this_opt, "vsync:", 6)) {
+		if (simple_strtoul(this_opt+6, NULL, 0) == 0) {
+			sprintf(s, "vsync: Active Low\n");
+			mode->sync &= ~FB_SYNC_VERT_HIGH_ACT;
+		} else {
+			sprintf(s, "vsync: Active High\n");
+			mode->sync |= FB_SYNC_VERT_HIGH_ACT;
+		}
+	} else if (!strncmp(this_opt, "dpc:", 4)) {
+		if (simple_strtoul(this_opt+4, NULL, 0) == 0) {
+			sprintf(s, "double pixel clock: false\n");
+			inf->lccr3 &= ~LCCR3_DPC;
+		} else {
+			sprintf(s, "double pixel clock: true\n");
+			inf->lccr3 |= LCCR3_DPC;
 		}
-        }
-        return 0;
+	} else if (!strncmp(this_opt, "outputen:", 9)) {
+		if (simple_strtoul(this_opt+9, NULL, 0) == 0) {
+			sprintf(s, "output enable: active low\n");
+			inf->lccr3 = (inf->lccr3 & ~LCCR3_OEP) | LCCR3_OutEnL;
+		} else {
+			sprintf(s, "output enable: active high\n");
+			inf->lccr3 = (inf->lccr3 & ~LCCR3_OEP) | LCCR3_OutEnH;
+		}
+	} else if (!strncmp(this_opt, "pixclockpol:", 12)) {
+		if (simple_strtoul(this_opt+12, NULL, 0) == 0) {
+			sprintf(s, "pixel clock polarity: falling edge\n");
+			inf->lccr3 = (inf->lccr3 & ~LCCR3_PCP) | LCCR3_PixFlEdg;
+		} else {
+			sprintf(s, "pixel clock polarity: rising edge\n");
+			inf->lccr3 = (inf->lccr3 & ~LCCR3_PCP) | LCCR3_PixRsEdg;
+		}
+	} else if (!strncmp(this_opt, "color", 5)) {
+		inf->lccr0 = (inf->lccr0 & ~LCCR0_CMS) | LCCR0_Color;
+	} else if (!strncmp(this_opt, "mono", 4)) {
+		inf->lccr0 = (inf->lccr0 & ~LCCR0_CMS) | LCCR0_Mono;
+	} else if (!strncmp(this_opt, "active", 6)) {
+		inf->lccr0 = (inf->lccr0 & ~LCCR0_PAS) | LCCR0_Act;
+	} else if (!strncmp(this_opt, "passive", 7)) {
+		inf->lccr0 = (inf->lccr0 & ~LCCR0_PAS) | LCCR0_Pas;
+	} else if (!strncmp(this_opt, "single", 6)) {
+		inf->lccr0 = (inf->lccr0 & ~LCCR0_SDS) | LCCR0_Sngl;
+	} else if (!strncmp(this_opt, "dual", 4)) {
+		inf->lccr0 = (inf->lccr0 & ~LCCR0_SDS) | LCCR0_Dual;
+	} else if (!strncmp(this_opt, "4pix", 4)) {
+		inf->lccr0 = (inf->lccr0 & ~LCCR0_DPD) | LCCR0_4PixMono;
+	} else if (!strncmp(this_opt, "8pix", 4)) {
+		inf->lccr0 = (inf->lccr0 & ~LCCR0_DPD) | LCCR0_8PixMono;
+	} else {
+		dev_err(dev, "unknown option: %s\n", this_opt);
+		return -EINVAL;
+	}
+
+	if (s[0] != '\0')
+		dev_info(dev, "override %s", s);
+
+	return 0;
+}
+
+static int __init pxafb_parse_options(struct device *dev, char *options)
+{
+	char *this_opt;
+	int ret;
+
+	if (!options || !*options)
+		return 0;
 
+	dev_dbg(dev, "options are \"%s\"\n", options ? options : "null");
+
+	/* could be made table driven or similar?... */
+	while ((this_opt = strsep(&options, ",")) != NULL) {
+		ret = parse_opt(dev, this_opt);
+		if (ret)
+			return ret;
+	}
+	return 0;
 }
 #endif
 
_

Patches currently in -mm which might be from eric.miao@marvell.com are

origin.patch
git-arm.patch
gpio-pca953x-add-support-for-pca9555-i2c-i-o-expander.patch

