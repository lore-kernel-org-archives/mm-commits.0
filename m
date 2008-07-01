From: akpm@linux-foundation.org
Subject: + pdflush-use-time_after-instead-of-open-coding-it.patch added to -mm tree
Date: Mon, 30 Jun 2008 20:34:20 -0700
Message-ID: <200807010334.m613YKjZ007148@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45664 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753109AbYGADeX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jun 2008 23:34:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hirofumi@mail.parknet.co.jp


The patch titled
     pdflush: use time_after() instead of open-coding it
has been added to the -mm tree.  Its filename is
     pdflush-use-time_after-instead-of-open-coding-it.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pdflush: use time_after() instead of open-coding it
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/pdflush.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/pdflush.c~pdflush-use-time_after-instead-of-open-coding-it mm/pdflush.c
--- a/mm/pdflush.c~pdflush-use-time_after-instead-of-open-coding-it
+++ a/mm/pdflush.c
@@ -130,7 +130,7 @@ static int __pdflush(struct pdflush_work
 		 * Thread creation: For how long have there been zero
 		 * available threads?
 		 */
-		if (jiffies - last_empty_jifs > 1 * HZ) {
+		if (time_after(jiffies, last_empty_jifs + 1 * HZ)) {
 			/* unlocked list_empty() test is OK here */
 			if (list_empty(&pdflush_list)) {
 				/* unlocked test is OK here */
@@ -151,7 +151,7 @@ static int __pdflush(struct pdflush_work
 		if (nr_pdflush_threads <= MIN_PDFLUSH_THREADS)
 			continue;
 		pdf = list_entry(pdflush_list.prev, struct pdflush_work, list);
-		if (jiffies - pdf->when_i_went_to_sleep > 1 * HZ) {
+		if (time_after(jiffies, pdf->when_i_went_to_sleep + 1 * HZ)) {
 			/* Limit exit rate */
 			pdf->when_i_went_to_sleep = jiffies;
 			break;					/* exeunt */
_

Patches currently in -mm which might be from hirofumi@mail.parknet.co.jp are

fat-fix-parse_options.patch
fat-fix-vfat_ioctl_readdir_xxx-and-cleanup-for-userland.patch
fat-dirc-switch-to-struct-__fat_dirent.patch
fat-cleanup-fs-fat-dirc.patch
fat-use-same-logic-in-fat_search_long-and-__fat_readdir.patch
fat-small-optimization-to-__fat_readdir.patch
pdflush-use-time_after-instead-of-open-coding-it.patch
msdos-fs-remove-unsettable-atari-option.patch
fat-dirc-switch-to-struct-__fat_fs_dirent.patch
remove-the-in-kernel-struct-dirent64.patch

