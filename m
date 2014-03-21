From: akpm@linux-foundation.org
Subject: +
 vmcore-continue-vmcore-initialization-if-pt_note-is-found-empty.patch added to -mm tree
Date: Fri, 21 Mar 2014 13:28:02 -0700
Message-ID: <532ca0d2.YcUO/wLknwwkJOKr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48049 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223AbaCUU2D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Mar 2014 16:28:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vgoyal@redhat.com, greg.pearson@hp.com, d.hatayama@jp.fujitsu.com, bhe@redhat.com, chaowang@redhat.com

Subject: + vmcore-continue-vmcore-initialization-if-pt_note-is-found-empty.patch added to -mm tree
To: chaowang@redhat.com,bhe@redhat.com,d.hatayama@jp.fujitsu.com,greg.pearson@hp.com,vgoyal@redhat.com
From: akpm@linux-foundation.org
Date: Fri, 21 Mar 2014 13:28:02 -0700


The patch titled
     Subject: vmcore: continue vmcore initialization if PT_NOTE is found empty
has been added to the -mm tree.  Its filename is
     vmcore-continue-vmcore-initialization-if-pt_note-is-found-empty.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/vmcore-continue-vmcore-initialization-if-pt_note-is-found-empty.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/vmcore-continue-vmcore-initialization-if-pt_note-is-found-empty.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

vmcore-continue-vmcore-initialization-if-pt_note-is-found-empty.patch

