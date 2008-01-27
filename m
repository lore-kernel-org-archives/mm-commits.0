From: akpm@linux-foundation.org
Subject: + oss-constify-function-pointer-tables.patch added to -mm tree
Date: Sat, 26 Jan 2008 21:18:40 -0800
Message-ID: <200801270518.m0R5IbmK031211@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49299 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751480AbYA0FXc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Jan 2008 00:23:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jengelh@computergmbh.de


The patch titled
     OSS: constify function pointer tables
has been added to the -mm tree.  Its filename is
     oss-constify-function-pointer-tables.patch

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
Subject: OSS: constify function pointer tables
From: Jan Engelhardt <jengelh@computergmbh.de>

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/oss/swarm_cs4297a.c |    4 ++--
 sound/oss/trident.c       |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN sound/oss/swarm_cs4297a.c~oss-constify-function-pointer-tables sound/oss/swarm_cs4297a.c
--- a/sound/oss/swarm_cs4297a.c~oss-constify-function-pointer-tables
+++ a/sound/oss/swarm_cs4297a.c
@@ -1580,7 +1580,7 @@ static int cs4297a_ioctl_mixdev(struct i
 // ******************************************************************************************
 //   Mixer file operations struct.
 // ******************************************************************************************
-static /*const */ struct file_operations cs4297a_mixer_fops = {
+static const struct file_operations cs4297a_mixer_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.ioctl		= cs4297a_ioctl_mixdev,
@@ -2491,7 +2491,7 @@ static int cs4297a_open(struct inode *in
 // ******************************************************************************************
 //   Wave (audio) file operations struct.
 // ******************************************************************************************
-static /*const */ struct file_operations cs4297a_audio_fops = {
+static const struct file_operations cs4297a_audio_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.read		= cs4297a_read,
diff -puN sound/oss/trident.c~oss-constify-function-pointer-tables sound/oss/trident.c
--- a/sound/oss/trident.c~oss-constify-function-pointer-tables
+++ a/sound/oss/trident.c
@@ -2878,7 +2878,7 @@ trident_release(struct inode *inode, str
 	return 0;
 }
 
-static /*const */ struct file_operations trident_audio_fops = {
+static const struct file_operations trident_audio_fops = {
 	.owner = THIS_MODULE,
 	.llseek = no_llseek,
 	.read = trident_read,
@@ -4104,7 +4104,7 @@ trident_ioctl_mixdev(struct inode *inode
 	return codec->mixer_ioctl(codec, cmd, arg);
 }
 
-static /*const */ struct file_operations trident_mixer_fops = {
+static const struct file_operations trident_mixer_fops = {
 	.owner = THIS_MODULE,
 	.llseek = no_llseek,
 	.ioctl = trident_ioctl_mixdev,
_

Patches currently in -mm which might be from jengelh@computergmbh.de are

git-kbuild.patch
git-net.patch
git-unionfs.patch
git-x86.patch
fs-fat-refine-chmod-checks.patch
documentation-about-unaligned-memory-access.patch
char-mxser-reorder-mxser_cardinfo-fields.patch
char-mxser-simplify-mxser_get_serial_info.patch
reiserfs-constify-function-pointer-tables.patch
procfs-constify-function-pointer-tables.patch
oss-constify-function-pointer-tables.patch
