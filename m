From: akpm@linux-foundation.org
Subject: + console-utf-8-fixes.patch added to -mm tree
Date: Fri, 20 Apr 2007 13:21:19 -0700
Message-ID: <200704202021.l3KKLJHr023035@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:46579 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767230AbXDTUVh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Apr 2007 16:21:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: egmont@uhulinux.hu, adaplas@pol.net, alan@lxorguk.ukuu.org.uk, hpa@zytor.com, jengelh@linux01.gwdg.de


The patch titled
     console UTF-8 fixes
has been added to the -mm tree.  Its filename is
     console-utf-8-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: console UTF-8 fixes
From: Egmont Koblinger <egmont@uhulinux.hu>

The UTF-8 part of the vt driver suffers from the following issues which are
addressed in my patch:

1) If there's no glyph found for a particular valid UTF-8 character, we try
   to display U+FFFD. However if this one is not found either, here's what
   the current kernel does:

   - First, if the Unicode value is less than the number of glyphs, use the
     glyph directly from that position of the glyph table. While it may be a
     good idea in the 8-bit world, it has absolutely no sense with Unicode
     in mind. For example, if a Latin-2 font is loaded and an application
     prints U+00FB ("u with circumflex", not present in Latin-2) then as a
     fallback solution the glyph from the 0xFB position of the Latin-2
     fontset (which is an "u with double accent" - a different character) is
     displayed.

   - Second, if this fallback fails too, a simple ASCII question mark is
     printed, which is visually undistinguishable from a real question mark.

   I changed the code to skip the first step (except if in non-UTF-8 mode),
   and changed the second step to print the question mark with inverse color
   attributes, so it is visually clear that it's not a real question mark,
   and resembles more to the common glyph of U+FFFD.

2) The UTF-8 decoder is buggy in many ways:

   - Lone continuation bytes (section 3.1 of Markus Kuhn's UTF-8 stress
     test) are not caught, they are displayed as some "random" (taken
     directly form the font table, see above) glyphs instead the replacement
     character.

   - Incomplete sequences (sections 3.2 and 3.3 of the stress test) emit no
     replacement character, but rather cause the subsequent valid character
     to be displayed more times(!).

   - The decoder is not safe: overlong sequences are not caught currently,
     they are displayed as if these were valid representations. This may
     even have security impacts.

   - The decoder does not handle D800..DFFF and FFFE..FFFF specially, it
     just emits these code points and lets it be looked up in the glyph
     table. Since these are invalid code points, I replace them by U+FFFD
     and hence give no chance for them to be looked up in the glyph table.
     (Assuming no font ships glyphs for these code points, this change is
     not visible to the users since the glyph shown will be the same.)

   With my fixes to the decoder it now behaves exactly as Markus Kuhn's
   stress test recommends.

3) It has no concept of double-width (CJK) characters. It's way beyond the
   scope of my patch to try to display them, but at least I think it's
   important for the cursor to jump two positions when printing such
   characters, since this is what applications (such as text editors)
   expect. Currently the cursor only jumps one position, and hence
   applications suffer from displaying and refreshing problems, and editing
   some English letters that are preceded by some CJK characters in the same
   line is a nightmare. With my patch an additional space is inserted after
   the CJK character has been printed (which usually means a replacement
   symbol of course). (If U+FFFD isn't availble and hence an inverse
   question mark is displayed in the first cell, I keep the inverted state
   for the space in the 2nd column so it's quite easy to see that they are
   tied together.)

4) There is a small built-in table of zero-width spaces that are not to be
   printed but silently skipped. U+200A is included there, but it's not a
   zero-width character, so I remove it from there.

Signed-off-by: Egmont Koblinger <egmont@uhulinux.hu>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/consolemap.c |    6 
 drivers/char/vt.c         |  257 +++++++++++++++++++++++++-----------
 2 files changed, 182 insertions(+), 81 deletions(-)

diff -puN drivers/char/consolemap.c~console-utf-8-fixes drivers/char/consolemap.c
--- a/drivers/char/consolemap.c~console-utf-8-fixes
+++ a/drivers/char/consolemap.c
@@ -626,10 +626,10 @@ conv_uni_to_pc(struct vc_data *conp, lon
   
 	/* Only 16-bit codes supported at this time */
 	if (ucs > 0xffff)
-		ucs = 0xfffd;		/* U+FFFD: REPLACEMENT CHARACTER */
-	else if (ucs < 0x20 || ucs >= 0xfffe)
+		return -4;		/* Not found */
+	else if (ucs < 0x20)
 		return -1;		/* Not a printable character */
-	else if (ucs == 0xfeff || (ucs >= 0x200a && ucs <= 0x200f))
+	else if (ucs == 0xfeff || (ucs >= 0x200b && ucs <= 0x200f))
 		return -2;			/* Zero-width space */
 	/*
 	 * UNI_DIRECT_BASE indicates the start of the region in the User Zone
diff -puN drivers/char/vt.c~console-utf-8-fixes drivers/char/vt.c
--- a/drivers/char/vt.c~console-utf-8-fixes
+++ a/drivers/char/vt.c
@@ -1932,6 +1932,46 @@ static void do_con_trol(struct tty_struc
 char con_buf[CON_BUF_SIZE];
 DECLARE_MUTEX(con_buf_sem);
 
+/* is_double_width() is based on the wcwidth() implementation by
+ * Markus Kuhn -- 2003-05-20 (Unicode 4.0)
+ * Latest version: http://www.cl.cam.ac.uk/~mgk25/ucs/wcwidth.c
+ */
+struct interval {
+	uint32_t first;
+	uint32_t last;
+};
+
+static int bisearch(uint32_t ucs, const struct interval *table, int max)
+{
+	int min = 0;
+	int mid;
+
+	if (ucs < table[0].first || ucs > table[max].last)
+		return 0;
+	while (max >= min) {
+		mid = (min + max) / 2;
+		if (ucs > table[mid].last)
+			min = mid + 1;
+		else if (ucs < table[mid].first)
+			max = mid - 1;
+		else
+			return 1;
+	}
+	return 0;
+}
+
+static int is_double_width(uint32_t ucs)
+{
+	static const struct interval double_width[] = {
+		{ 0x1100, 0x115F }, { 0x2329, 0x232A }, { 0x2E80, 0x303E },
+		{ 0x3040, 0xA4CF }, { 0xAC00, 0xD7A3 }, { 0xF900, 0xFAFF },
+		{ 0xFE30, 0xFE6F }, { 0xFF00, 0xFF60 }, { 0xFFE0, 0xFFE6 },
+		{ 0x20000, 0x2FFFD }, { 0x30000, 0x3FFFD }
+	};
+	return bisearch(ucs, double_width,
+		sizeof(double_width) / sizeof(*double_width) - 1);
+}
+
 /* acquires console_sem */
 static int do_con_write(struct tty_struct *tty, const unsigned char *buf, int count)
 {
@@ -1948,6 +1988,10 @@ static int do_con_write(struct tty_struc
 	unsigned int currcons;
 	unsigned long draw_from = 0, draw_to = 0;
 	struct vc_data *vc;
+	unsigned char vc_attr;
+	uint8_t rescan;
+	uint8_t inverse;
+	uint8_t width;
 	u16 himask, charmask;
 	const unsigned char *orig_buf = NULL;
 	int orig_count;
@@ -2010,53 +2054,86 @@ static int do_con_write(struct tty_struc
 		buf++;
 		n++;
 		count--;
+		rescan = 0;
+		inverse = 0;
+		width = 1;
 
 		/* Do no translation at all in control states */
 		if (vc->vc_state != ESnormal) {
 			tc = c;
 		} else if (vc->vc_utf && !vc->vc_disp_ctrl) {
-		    /* Combine UTF-8 into Unicode */
-		    /* Malformed sequences as sequences of replacement glyphs */
+		    /* Combine UTF-8 into Unicode in vc_utf_char.
+		     * vc_utf_count is the number of continuation bytes still
+		     * expected to arrive.
+		     * vc_npar is the number of continuation bytes arrived so
+		     * far
+		     */
 rescan_last_byte:
-		    if(c > 0x7f) {
+		    if ((c & 0xc0) == 0x80) {
+			/* Continuation byte received */
+			static const uint32_t utf8_length_changes[] = { 0x0000007f, 0x000007ff, 0x0000ffff, 0x001fffff, 0x03ffffff, 0x7fffffff };
 			if (vc->vc_utf_count) {
-			       if ((c & 0xc0) == 0x80) {
-				       vc->vc_utf_char = (vc->vc_utf_char << 6) | (c & 0x3f);
-       				       if (--vc->vc_utf_count) {
-					       vc->vc_npar++;
-				   	       continue;
-       				       }
-				       tc = c = vc->vc_utf_char;
-			       } else
-				       goto replacement_glyph;
-			} else {
-				vc->vc_npar = 0;
-				if ((c & 0xe0) == 0xc0) {
-				    vc->vc_utf_count = 1;
-				    vc->vc_utf_char = (c & 0x1f);
-				} else if ((c & 0xf0) == 0xe0) {
-				    vc->vc_utf_count = 2;
-				    vc->vc_utf_char = (c & 0x0f);
-				} else if ((c & 0xf8) == 0xf0) {
-				    vc->vc_utf_count = 3;
-				    vc->vc_utf_char = (c & 0x07);
-				} else if ((c & 0xfc) == 0xf8) {
-				    vc->vc_utf_count = 4;
-				    vc->vc_utf_char = (c & 0x03);
-				} else if ((c & 0xfe) == 0xfc) {
-				    vc->vc_utf_count = 5;
-				    vc->vc_utf_char = (c & 0x01);
-				} else
-	    			    goto replacement_glyph;
+			    vc->vc_utf_char = (vc->vc_utf_char << 6) | (c & 0x3f);
+			    vc->vc_npar++;
+			    if (--vc->vc_utf_count) {
+				/* Still need some bytes */
 				continue;
-			      }
+			    }
+			    /* Got a whole character */
+			    c = vc->vc_utf_char;
+			    /* Reject overlong sequences */
+			    if (c <= utf8_length_changes[vc->vc_npar - 1] ||
+					c > utf8_length_changes[vc->vc_npar])
+				c = 0xfffd;
+			} else {
+			    /* Unexpected continuation byte */
+			    vc->vc_utf_count = 0;
+			    c = 0xfffd;
+			}
 		    } else {
-		      if (vc->vc_utf_count)
-	  		      goto replacement_glyph;
-		      tc = c;
+			/* Single ASCII byte or first byte of a sequence received */
+			if (vc->vc_utf_count) {
+			    /* Continuation byte expected */
+			    rescan = 1;
+			    vc->vc_utf_count = 0;
+			    c = 0xfffd;
+			} else if (c > 0x7f) {
+			    /* First byte of a multibyte sequence received */
+			    vc->vc_npar = 0;
+			    if ((c & 0xe0) == 0xc0) {
+				vc->vc_utf_count = 1;
+				vc->vc_utf_char = (c & 0x1f);
+			    } else if ((c & 0xf0) == 0xe0) {
+				vc->vc_utf_count = 2;
+				vc->vc_utf_char = (c & 0x0f);
+			    } else if ((c & 0xf8) == 0xf0) {
+				vc->vc_utf_count = 3;
+				vc->vc_utf_char = (c & 0x07);
+			    } else if ((c & 0xfc) == 0xf8) {
+				vc->vc_utf_count = 4;
+				vc->vc_utf_char = (c & 0x03);
+			    } else if ((c & 0xfe) == 0xfc) {
+				vc->vc_utf_count = 5;
+				vc->vc_utf_char = (c & 0x01);
+			    } else {
+				/* 254 and 255 are invalid */
+				c = 0xfffd;
+			    }
+			    if (vc->vc_utf_count) {
+				/* Still need some bytes */
+				continue;
+			    }
+			}
+			/* Nothing to do if an ASCII byte was received */
 		    }
+		    /* End of UTF-8 decoding. */
+		    /* c is the received character, or U+FFFD for invalid sequences. */
+		    /* Replace invalid Unicode code points with U+FFFD too */
+		    if ((c >= 0xd800 && c <= 0xdfff) || c == 0xfffe || c == 0xffff)
+			c = 0xfffd;
+		    tc = c;
 		} else {	/* no utf or alternate charset mode */
-		  tc = vc->vc_translate[vc->vc_toggle_meta ? (c | 0x80) : c];
+		    tc = vc->vc_translate[vc->vc_toggle_meta ? (c | 0x80) : c];
 		}
 
                 /* If the original code was a control character we
@@ -2076,56 +2153,80 @@ rescan_last_byte:
 			&& (c != 128+27);
 
 		if (vc->vc_state == ESnormal && ok) {
+			if (vc->vc_utf && !vc->vc_disp_ctrl) {
+				if (is_double_width(c))
+					width = 2;
+			}
 			/* Now try to find out how to display it */
 			tc = conv_uni_to_pc(vc, tc);
 			if (tc & ~charmask) {
-				if ( tc == -4 ) {
-                                /* If we got -4 (not found) then see if we have
-                                   defined a replacement character (U+FFFD) */
-replacement_glyph:
-                                	tc = conv_uni_to_pc(vc, 0xfffd);
-					if (!(tc & ~charmask))
-						goto display_glyph;
-                        	} else if ( tc != -3 )
-                                	continue; /* nothing to display */
-                                /* no hash table or no replacement --
-				 * hope for the best */
-				if ( c & ~charmask )
-					tc = '?';
-				else
-					tc = c;
+				if (tc == -1 || tc == -2) {
+				    continue; /* nothing to display */
+				}
+				/* Glyph not found */
+				if (!(vc->vc_utf && !vc->vc_disp_ctrl) && !(c & ~charmask)) {
+				    /* In legacy mode use the glyph we get by a 1:1 mapping.
+				       This would make absolutely no sense with Unicode in mind. */
+				    tc = c;
+				} else {
+				    /* Display U+FFFD. If it's not found, display an inverse question mark. */
+				    tc = conv_uni_to_pc(vc, 0xfffd);
+				    if (tc < 0) {
+					inverse = 1;
+					tc = conv_uni_to_pc(vc, '?');
+					if (tc < 0) tc = '?';
+				    }
+				}
 			}
 
-display_glyph:
-			if (vc->vc_need_wrap || vc->vc_decim)
-				FLUSH
-			if (vc->vc_need_wrap) {
-				cr(vc);
-				lf(vc);
-			}
-			if (vc->vc_decim)
-				insert_char(vc, 1);
-			scr_writew(himask ?
-				     ((vc->vc_attr << 8) & ~himask) + ((tc & 0x100) ? himask : 0) + (tc & 0xff) :
-				     (vc->vc_attr << 8) + tc,
-				   (u16 *) vc->vc_pos);
-			if (DO_UPDATE(vc) && draw_x < 0) {
-				draw_x = vc->vc_x;
-				draw_from = vc->vc_pos;
-			}
-			if (vc->vc_x == vc->vc_cols - 1) {
-				vc->vc_need_wrap = vc->vc_decawm;
-				draw_to = vc->vc_pos + 2;
+			if (!inverse) {
+				vc_attr = vc->vc_attr;
 			} else {
-				vc->vc_x++;
-				draw_to = (vc->vc_pos += 2);
+				/* invert vc_attr */
+				if (!vc->vc_can_do_color) {
+					vc_attr = (vc->vc_attr) ^ 0x08;
+				} else if (vc->vc_hi_font_mask == 0x100) {
+					vc_attr = ((vc->vc_attr) & 0x11) | (((vc->vc_attr) & 0xe0) >> 4) | (((vc->vc_attr) & 0x0e) << 4);
+				} else {
+					vc_attr = ((vc->vc_attr) & 0x88) | (((vc->vc_attr) & 0x70) >> 4) | (((vc->vc_attr) & 0x07) << 4);
+				}
 			}
-			if (vc->vc_utf_count) {
-				if (vc->vc_npar) {
-					vc->vc_npar--;
-					goto display_glyph;
+
+			while (1) {
+				if (vc->vc_need_wrap || vc->vc_decim)
+					FLUSH
+				if (vc->vc_need_wrap) {
+					cr(vc);
+					lf(vc);
+				}
+				if (vc->vc_decim)
+					insert_char(vc, 1);
+				scr_writew(himask ?
+					     ((vc_attr << 8) & ~himask) + ((tc & 0x100) ? himask : 0) + (tc & 0xff) :
+					     (vc_attr << 8) + tc,
+					   (u16 *) vc->vc_pos);
+				if (DO_UPDATE(vc) && draw_x < 0) {
+					draw_x = vc->vc_x;
+					draw_from = vc->vc_pos;
+				}
+				if (vc->vc_x == vc->vc_cols - 1) {
+					vc->vc_need_wrap = vc->vc_decawm;
+					draw_to = vc->vc_pos + 2;
+				} else {
+					vc->vc_x++;
+					draw_to = (vc->vc_pos += 2);
 				}
-				vc->vc_utf_count = 0;
+
+				if (!--width) break;
+
+				tc = conv_uni_to_pc(vc, ' '); /* A space is printed in the second column */
+				if (tc < 0) tc = ' ';
+			}
+
+			if (rescan) {
+				rescan = 0;
+				inverse = 0;
+				width = 1;
 				c = orig;
 				goto rescan_last_byte;
 			}
_

Patches currently in -mm which might be from egmont@uhulinux.hu are

console-utf-8-fixes.patch
