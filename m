From: akpm@linux-foundation.org
Subject: + kdump-append-newline-to-the-last-lien-of-vmcoreinfo-note.patch added to -mm tree
Date: Wed, 18 Jul 2012 15:05:06 -0700
Message-ID: <20120718220507.08C04200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:61435 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898Ab2GRWFJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jul 2012 18:05:09 -0400
Received: by lbbgp10 with SMTP id gp10so113869lbb.1
        for <mm-commits@vger.kernel.org>; Wed, 18 Jul 2012 15:05:08 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vgoyal@redhat.com, ebiederm@xmission.com


The patch titled
     Subject: kdump: append newline to the last lien of vmcoreinfo note
has been added to the -mm tree.  Its filename is
     kdump-append-newline-to-the-last-lien-of-vmcoreinfo-note.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: kdump: append newline to the last lien of vmcoreinfo note

Patches currently in -mm which might be from vgoyal@redhat.com are

kdump-append-newline-to-the-last-lien-of-vmcoreinfo-note.patch

