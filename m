From: akpm@linux-foundation.org
Subject: +
 vmcore-prevent-pt_note-p_memsz-overflow-during-header-update-v2.patch added to -mm tree
Date: Mon, 03 Feb 2014 13:21:52 -0800
Message-ID: <52f00870.16TjMMTdFI6Jd9xP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46740 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559AbaBCVV4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Feb 2014 16:21:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vgoyal@redhat.com, holzheu@linux.vnet.ibm.com, ebiederm@xmission.com, d.hatayama@jp.fujitsu.com, greg.pearson@hp.com

Subject: + vmcore-prevent-pt_note-p_memsz-overflow-during-header-update-v2.patch added to -mm tree
To: greg.pearson@hp.com,d.hatayama@jp.fujitsu.com,ebiederm@xmission.com,holzheu@linux.vnet.ibm.com,vgoyal@redhat.com
From: akpm@linux-foundation.org
Date: Mon, 03 Feb 2014 13:21:52 -0800


The patch titled
     Subject: vmcore-prevent-pt_note-p_memsz-overflow-during-header-update-v2
has been added to the -mm tree.  Its filename is
     vmcore-prevent-pt_note-p_memsz-overflow-during-header-update-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/vmcore-prevent-pt_note-p_memsz-overflow-during-header-update-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/vmcore-prevent-pt_note-p_memsz-overflow-during-header-update-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Greg Pearson <greg.pearson@hp.com>
Subject: vmcore-prevent-pt_note-p_memsz-overflow-during-header-update-v2

Signed-off-by: Greg Pearson <greg.pearson@hp.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/vmcore.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN fs/proc/vmcore.c~vmcore-prevent-pt_note-p_memsz-overflow-during-header-update-v2 fs/proc/vmcore.c
--- a/fs/proc/vmcore.c~vmcore-prevent-pt_note-p_memsz-overflow-during-header-update-v2
+++ a/fs/proc/vmcore.c
@@ -472,9 +472,10 @@ static int __init update_note_header_siz
 			sz = sizeof(Elf64_Nhdr) +
 				((nhdr_ptr->n_namesz + 3) & ~3) +
 				((nhdr_ptr->n_descsz + 3) & ~3);
-			/* Silently drop further PT_NOTE entries */
-			if ((real_sz + sz) > max_sz)
+			if ((real_sz + sz) > max_sz) {
+				pr_warn("Warning: dropping PT_NOTE entry\n");
 				break;
+			}
 			real_sz += sz;
 			nhdr_ptr = (Elf64_Nhdr*)((char*)nhdr_ptr + sz);
 		}
@@ -653,9 +654,10 @@ static int __init update_note_header_siz
 			sz = sizeof(Elf32_Nhdr) +
 				((nhdr_ptr->n_namesz + 3) & ~3) +
 				((nhdr_ptr->n_descsz + 3) & ~3);
-			/* Silently drop further PT_NOTE entries */
-			if ((real_sz + sz) > max_sz)
+			if ((real_sz + sz) > max_sz) {
+				pr_warn("Warning: dropping PT_NOTE entry\n");
 				break;
+			}
 			real_sz += sz;
 			nhdr_ptr = (Elf32_Nhdr*)((char*)nhdr_ptr + sz);
 		}
_

Patches currently in -mm which might be from greg.pearson@hp.com are

vmcore-prevent-pt_note-p_memsz-overflow-during-header-update.patch
vmcore-prevent-pt_note-p_memsz-overflow-during-header-update-v2.patch

