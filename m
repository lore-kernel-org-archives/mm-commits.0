From: akpm@linux-foundation.org
Subject: [merged] seq-file-use-seek_-macros-instead-of-hardcoded-numbers.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:11:55 -0800
Message-ID: <20130228201155.AED2931C0A0@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:49540 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755781Ab3B1UL4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:11:56 -0500
Received: by mail-gh0-f202.google.com with SMTP id z10so244631ghb.1
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:11:56 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@openvz.org, mm-commits@vger.kernel.org


The patch titled
     Subject: seq-file: use SEEK_ macros instead of hardcoded numbers
has been removed from the -mm tree.  Its filename was
     seq-file-use-seek_-macros-instead-of-hardcoded-numbers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: seq-file: use SEEK_ macros instead of hardcoded numbers

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/seq_file.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/seq_file.c~seq-file-use-seek_-macros-instead-of-hardcoded-numbers fs/seq_file.c
--- a/fs/seq_file.c~seq-file-use-seek_-macros-instead-of-hardcoded-numbers
+++ a/fs/seq_file.c
@@ -308,9 +308,9 @@ loff_t seq_lseek(struct file *file, loff
 	mutex_lock(&m->lock);
 	m->version = file->f_version;
 	switch (whence) {
-		case 1:
+		case SEEK_CUR:
 			offset += file->f_pos;
-		case 0:
+		case SEEK_SET:
 			if (offset < 0)
 				break;
 			retval = offset;
_

Patches currently in -mm which might be from gorcunov@openvz.org are

origin.patch
arm-wire-up-kcmp-syscall.patch
kernel-sysc-make-prctlpr_set_mm-generally-available.patch

