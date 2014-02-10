From: akpm@linux-foundation.org
Subject: [folded-merged]
 vmcore-prevent-pt_note-p_memsz-overflow-during-header-update-v3.patch
 removed from -mm tree
Date: Mon, 10 Feb 2014 14:21:03 -0800
Message-ID: <52f950cf.CbNugviCddlXAe0m%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58954 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392AbaBJWVE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 10 Feb 2014 17:21:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vgoyal@redhat.com, holzheu@linux.vnet.ibm.com, ebiederm@xmission.com, d.hatayama@jp.fujitsu.com, greg.pearson@hp.com

Subject: [folded-merged] vmcore-prevent-pt_note-p_memsz-overflow-during-header-update-v3.patch removed from -mm tree
To: greg.pearson@hp.com,d.hatayama@jp.fujitsu.com,ebiederm@xmission.com,holzheu@linux.vnet.ibm.com,vgoyal@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 10 Feb 2014 14:21:03 -0800


The patch titled
     Subject: vmcore-prevent-pt_note-p_memsz-overflow-during-header-update-v3
has been removed from the -mm tree.  Its filename was
     vmcore-prevent-pt_note-p_memsz-overflow-during-header-update-v3.patch

This patch was dropped because it was folded into vmcore-prevent-pt_note-p_memsz-overflow-during-header-update.patch

------------------------------------------------------
From: Greg Pearson <greg.pearson@hp.com>
Subject: vmcore-prevent-pt_note-p_memsz-overflow-during-header-update-v3

Signed-off-by: Greg Pearson <greg.pearson@hp.com>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/vmcore.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff -puN fs/proc/vmcore.c~vmcore-prevent-pt_note-p_memsz-overflow-during-header-update-v3 fs/proc/vmcore.c
--- a/fs/proc/vmcore.c~vmcore-prevent-pt_note-p_memsz-overflow-during-header-update-v3
+++ a/fs/proc/vmcore.c
@@ -473,7 +473,8 @@ static int __init update_note_header_siz
 				((nhdr_ptr->n_namesz + 3) & ~3) +
 				((nhdr_ptr->n_descsz + 3) & ~3);
 			if ((real_sz + sz) > max_sz) {
-				pr_warn("Warning: dropping PT_NOTE entry\n");
+				pr_warn("Warning: Exceeded p_memsz, dropping PT_NOTE entry n_namesz=0x%x, n_descsz=0x%x\n",
+					nhdr_ptr->n_namesz, nhdr_ptr->n_descsz);
 				break;
 			}
 			real_sz += sz;
@@ -481,6 +482,10 @@ static int __init update_note_header_siz
 		}
 		kfree(notes_section);
 		phdr_ptr->p_memsz = real_sz;
+		if (real_sz == 0) {
+			pr_warn("Warning: Zero PT_NOTE entries found\n");
+			return -EINVAL;
+		}
 	}
 
 	return 0;
@@ -655,7 +660,8 @@ static int __init update_note_header_siz
 				((nhdr_ptr->n_namesz + 3) & ~3) +
 				((nhdr_ptr->n_descsz + 3) & ~3);
 			if ((real_sz + sz) > max_sz) {
-				pr_warn("Warning: dropping PT_NOTE entry\n");
+				pr_warn("Warning: Exceeded p_memsz, dropping PT_NOTE entry n_namesz=0x%x, n_descsz=0x%x\n",
+					nhdr_ptr->n_namesz, nhdr_ptr->n_descsz);
 				break;
 			}
 			real_sz += sz;
@@ -663,6 +669,10 @@ static int __init update_note_header_siz
 		}
 		kfree(notes_section);
 		phdr_ptr->p_memsz = real_sz;
+		if (real_sz == 0) {
+			pr_warn("Warning: Zero PT_NOTE entries found\n");
+			return -EINVAL;
+		}
 	}
 
 	return 0;
_

Patches currently in -mm which might be from greg.pearson@hp.com are

vmcore-prevent-pt_note-p_memsz-overflow-during-header-update.patch

