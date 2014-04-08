From: akpm@linux-foundation.org
Subject: [merged]
 vmcore-continue-vmcore-initialization-if-pt_note-is-found-empty.patch
 removed from -mm tree
Date: Tue, 08 Apr 2014 14:23:49 -0700
Message-ID: <534468e5.dYSDAvyPrkRjsRIL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56968 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757441AbaDHVXu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 17:23:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vgoyal@redhat.com, greg.pearson@hp.com, d.hatayama@jp.fujitsu.com, bhe@redhat.com, chaowang@redhat.com

Subject: [merged] vmcore-continue-vmcore-initialization-if-pt_note-is-found-empty.patch removed from -mm tree
To: chaowang@redhat.com,bhe@redhat.com,d.hatayama@jp.fujitsu.com,greg.pearson@hp.com,vgoyal@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 14:23:49 -0700


The patch titled
     Subject: vmcore: continue vmcore initialization if PT_NOTE is found empty
has been removed from the -mm tree.  Its filename was
     vmcore-continue-vmcore-initialization-if-pt_note-is-found-empty.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: WANG Chao <chaowang@redhat.com>
Subject: vmcore: continue vmcore initialization if PT_NOTE is found empty

Currently when an empty PT_NOTE is detected, vmcore initialization
fails. It sounds too harsh. Because PT_NOTE could be empty, for example,
one offlined a cpu but never restarted kdump service, and after crash,
PT_NOTE program header is there but no data contains. It's better to
warn about the empty PT_NOTE and continue to initialise vmcore.

And ultimately the multiple PT_NOTE are merged into a single one, all
empty PT_NOTE are discarded naturally during the merge. So empty PT_NOTE
is not visible to user space and vmcore is as good as expected.

Signed-off-by: WANG Chao <chaowang@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: Greg Pearson <greg.pearson@hp.com>
Cc: Baoquan He <bhe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/vmcore.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN fs/proc/vmcore.c~vmcore-continue-vmcore-initialization-if-pt_note-is-found-empty fs/proc/vmcore.c
--- a/fs/proc/vmcore.c~vmcore-continue-vmcore-initialization-if-pt_note-is-found-empty
+++ a/fs/proc/vmcore.c
@@ -484,7 +484,6 @@ static int __init update_note_header_siz
 		phdr_ptr->p_memsz = real_sz;
 		if (real_sz == 0) {
 			pr_warn("Warning: Zero PT_NOTE entries found\n");
-			return -EINVAL;
 		}
 	}
 
@@ -671,7 +670,6 @@ static int __init update_note_header_siz
 		phdr_ptr->p_memsz = real_sz;
 		if (real_sz == 0) {
 			pr_warn("Warning: Zero PT_NOTE entries found\n");
-			return -EINVAL;
 		}
 	}
 
_

Patches currently in -mm which might be from chaowang@redhat.com are

origin.patch

