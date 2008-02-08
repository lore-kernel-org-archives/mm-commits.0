From: akpm@linux-foundation.org
Subject: - oss-constify-function-pointer-tables.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:19:02 -0800
Message-ID: <200802082018.m18KIhU0010952@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39043 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762524AbYBHUmd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:42:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jengelh@computergmbh.de, mm-commits@vger.kernel.org


The patch titled
     OSS: constify function pointer tables
has been removed from the -mm tree.  Its filename was
     oss-constify-function-pointer-tables.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
git-dvb.patch
git-kvm.patch
git-ocfs2.patch
git-unionfs.patch
git-watchdog.patch
