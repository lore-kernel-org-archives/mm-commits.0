From: akpm@linux-foundation.org
Subject: + proc-proc_get_inode-should-get-module-only-once.patch added to -mm tree
Date: Wed, 21 May 2008 14:38:42 -0700
Message-ID: <200805212138.m4LLcgew002097@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59108 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755154AbYEUVi6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 May 2008 17:38:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: den@openvz.org, davem@davemloft.net, devzero@web.de, ebiederm@xmission.com, kaber@trash.net, robert.olsson@its.uu.se, xemul@openvz.org


The patch titled
     proc: proc_get_inode() should get module only once
has been added to the -mm tree.  Its filename is
     proc-proc_get_inode-should-get-module-only-once.patch

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
Subject: proc: proc_get_inode() should get module only once
From: "Denis V. Lunev" <den@openvz.org>

Any file under /proc/net opened more than once leaked the refcounter
on the module it belongs to.

The problem is that module_get is called for each file opening while
module_put is called only when /proc inode is destroyed. So, lets put
module counter if we are dealing with already initialised inode.

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=10737

Signed-off-by: Denis V. Lunev <den@openvz.org>
Cc: David Miller <davem@davemloft.net>
Cc: Patrick McHardy <kaber@trash.net>
Acked-by: Pavel Emelyanov <xemul@openvz.org>
Acked-by: Robert Olsson <robert.olsson@its.uu.se>
Acked-by: Eric W. Biederman <ebiederm@xmission.com>
Reported-by: Roland Kletzing <devzero@web.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/inode.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/proc/inode.c~proc-proc_get_inode-should-get-module-only-once fs/proc/inode.c
--- a/fs/proc/inode.c~proc-proc_get_inode-should-get-module-only-once
+++ a/fs/proc/inode.c
@@ -425,7 +425,8 @@ struct inode *proc_get_inode(struct supe
 			}
 		}
 		unlock_new_inode(inode);
-	}
+	} else
+	       module_put(de->owner);
 	return inode;
 
 out_ino:
_

Patches currently in -mm which might be from den@openvz.org are

origin.patch
proc-proc_get_inode-should-get-module-only-once.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch
pktgen-make-sure-that-pktgen_thread_worker-has-been-executed.patch
modules-proper-cleanup-of-kobject-without-config_sysfs.patch
flock-remove-unused-fields-from-file_lock_operations.patch

