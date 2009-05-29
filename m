From: akpm@linux-foundation.org
Subject: + s3c-fb-cpufreq-frequency-scaling-support.patch added to -mm tree
Date: Fri, 29 May 2009 13:45:06 -0700
Message-ID: <200905292045.n4TKj6hJ000624@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51013 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752201AbZE2UqM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 May 2009 16:46:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben@simtec.co.uk, davej@codemonkey.org.uk, linux@simtec.co.uk


The patch titled
     s3c-fb: CPUFREQ frequency scaling support
has been added to the -mm tree.  Its filename is
     s3c-fb-cpufreq-frequency-scaling-support.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: s3c-fb: CPUFREQ frequency scaling support
From: Ben Dooks <ben@simtec.co.uk>

Add support for CPU frequency scaling in the S3C24XX video driver.

Signed-off-by: Simtec Linux Team <linux@simtec.co.uk>
Signed-off-by: Ben Dooks <ben@simtec.co.uk>
Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/s3c2410fb.c |   67 ++++++++++++++++++++++++++++++++++--
 drivers/video/s3c2410fb.h |    5 ++
 2 files changed, 70 insertions(+), 2 deletions(-)

diff -puN drivers/video/s3c2410fb.c~s3c-fb-cpufreq-frequency-scaling-support drivers/video/s3c2410fb.c
--- a/drivers/video/s3c2410fb.c~s3c-fb-cpufreq-frequency-scaling-support
+++ a/drivers/video/s3c2410fb.c
@@ -24,6 +24,7 @@
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
 #include <linux/clk.h>
+#include <linux/cpufreq.h>
 
 #include <asm/io.h>
 #include <asm/div64.h>
@@ -89,7 +90,7 @@ static void s3c2410fb_set_lcdaddr(struct
 static unsigned int s3c2410fb_calc_pixclk(struct s3c2410fb_info *fbi,
 					  unsigned long pixclk)
 {
-	unsigned long clk = clk_get_rate(fbi->clk);
+	unsigned long clk = fbi->clk_rate;
 	unsigned long long div;
 
 	/* pixclk is in picoseconds, our clock is in Hz
@@ -758,6 +759,57 @@ static irqreturn_t s3c2410fb_irq(int irq
 	return IRQ_HANDLED;
 }
 
+#ifdef CONFIG_CPU_FREQ
+
+static int s3c2410fb_cpufreq_transition(struct notifier_block *nb,
+					unsigned long val, void *data)
+{
+	struct cpufreq_freqs *freqs = data;
+	struct s3c2410fb_info *info;
+	struct fb_info *fbinfo;
+	long delta_f;
+
+	info = container_of(nb, struct s3c2410fb_info, freq_transition);
+	fbinfo = platform_get_drvdata(to_platform_device(info->dev));
+
+	/* work out change, <0 for speed-up */
+	delta_f = info->clk_rate - clk_get_rate(info->clk);
+
+	if ((val == CPUFREQ_POSTCHANGE && delta_f > 0) ||
+	    (val == CPUFREQ_PRECHANGE && delta_f < 0)) {
+		info->clk_rate = clk_get_rate(info->clk);
+		s3c2410fb_activate_var(fbinfo);
+	}
+
+	return 0;
+}
+
+static inline int s3c2410fb_cpufreq_register(struct s3c2410fb_info *info)
+{
+	info->freq_transition.notifier_call = s3c2410fb_cpufreq_transition;
+
+	return cpufreq_register_notifier(&info->freq_transition,
+					 CPUFREQ_TRANSITION_NOTIFIER);
+}
+
+static inline void s3c2410fb_cpufreq_deregister(struct s3c2410fb_info *info)
+{
+	cpufreq_unregister_notifier(&info->freq_transition,
+				    CPUFREQ_TRANSITION_NOTIFIER);
+}
+
+#else
+static inline int s3c2410fb_cpufreq_register(struct s3c2410fb_info *info)
+{
+	return 0;
+}
+
+static inline void s3c2410fb_cpufreq_deregister(struct s3c2410fb_info *info)
+{
+}
+#endif
+
+
 static char driver_name[] = "s3c2410fb";
 
 static int __init s3c24xxfb_probe(struct platform_device *pdev,
@@ -875,6 +927,8 @@ static int __init s3c24xxfb_probe(struct
 
 	msleep(1);
 
+	info->clk_rate = clk_get_rate(info->clk);
+
 	/* find maximum required memory size for display */
 	for (i = 0; i < mach_info->num_displays; i++) {
 		unsigned long smem_len = mach_info->displays[i].xres;
@@ -904,11 +958,17 @@ static int __init s3c24xxfb_probe(struct
 
 	s3c2410fb_check_var(&fbinfo->var, fbinfo);
 
+	ret = s3c2410fb_cpufreq_register(info);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "Failed to register cpufreq\n");
+		goto free_video_memory;
+	}
+
 	ret = register_framebuffer(fbinfo);
 	if (ret < 0) {
 		printk(KERN_ERR "Failed to register framebuffer device: %d\n",
 			ret);
-		goto free_video_memory;
+		goto free_cpufreq;
 	}
 
 	/* create device files */
@@ -922,6 +982,8 @@ static int __init s3c24xxfb_probe(struct
 
 	return 0;
 
+ free_cpufreq:
+	s3c2410fb_cpufreq_deregister(info);
 free_video_memory:
 	s3c2410fb_unmap_video_memory(fbinfo);
 release_clock:
@@ -961,6 +1023,7 @@ static int s3c2410fb_remove(struct platf
 	int irq;
 
 	unregister_framebuffer(fbinfo);
+	s3c2410fb_cpufreq_deregister(info);
 
 	s3c2410fb_lcd_enable(info, 0);
 	msleep(1);
diff -puN drivers/video/s3c2410fb.h~s3c-fb-cpufreq-frequency-scaling-support drivers/video/s3c2410fb.h
--- a/drivers/video/s3c2410fb.h~s3c-fb-cpufreq-frequency-scaling-support
+++ a/drivers/video/s3c2410fb.h
@@ -29,8 +29,13 @@ struct s3c2410fb_info {
 	enum s3c_drv_type	drv_type;
 	struct s3c2410fb_hw	regs;
 
+	unsigned long		clk_rate;
 	unsigned int		palette_ready;
 
+#ifdef CONFIG_CPU_FREQ
+	struct notifier_block	freq_transition;
+#endif
+
 	/* keep these registers in case we need to re-write palette */
 	u32			palette_buffer[256];
 	u32			pseudo_pal[16];
_

Patches currently in -mm which might be from ben@simtec.co.uk are

linux-next.patch
s3c-fb-cpufreq-frequency-scaling-support.patch

