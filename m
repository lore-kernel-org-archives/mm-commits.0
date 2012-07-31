From: akpm@linux-foundation.org
Subject: [merged] kdump-append-newline-to-the-last-lien-of-vmcoreinfo-note.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:54:03 -0700
Message-ID: <20120731185403.BE661100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:42024 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756378Ab2GaSyE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:54:04 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so4679387obb.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:54:04 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vgoyal@redhat.com, ebiederm@xmission.com, kumagai-atsushi@mxc.nes.nec.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: kdump: append newline to the last lien of vmcoreinfo note
has been removed from the -mm tree.  Its filename was
     kdump-append-newline-to-the-last-lien-of-vmcoreinfo-note.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vivek Goyal <vgoyal@redhat.com>
Subject: kdump: append newline to the last lien of vmcoreinfo note

The last line of vmcoreinfo note does not end with \n.  Parsing all the
lines in note becomes easier if all lines end with \n instead of trying to
special case the last line.

I know at least one tool, vmcore-dmesg in kexec-tools tree which made the
assumption that all lines end with \n.  I think it is a good idea to fix
it.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/kexec.c~kdump-append-newline-to-the-last-lien-of-vmcoreinfo-note kernel/kexec.c
--- a/kernel/kexec.c~kdump-append-newline-to-the-last-lien-of-vmcoreinfo-note
+++ a/kernel/kexec.c
@@ -1424,7 +1424,7 @@ static void update_vmcoreinfo_note(void)
 
 void crash_save_vmcoreinfo(void)
 {
-	vmcoreinfo_append_str("CRASHTIME=%ld", get_seconds());
+	vmcoreinfo_append_str("CRASHTIME=%ld\n", get_seconds());
 	update_vmcoreinfo_note();
 }
 
_

Patches currently in -mm which might be from vgoyal@redhat.com are

origin.patch

