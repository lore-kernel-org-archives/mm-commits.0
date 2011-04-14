From: akpm@linux-foundation.org
Subject: + ramfs-fix-memleak-on-no-mmu-arch.patch added to -mm tree
Date: Thu, 14 Apr 2011 12:15:17 -0700
Message-ID: <201104141915.p3EJFHw4001143@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39267 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759172Ab1DNTQC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Apr 2011 15:16:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lliubbo@gmail.com, dhowells@redhat.com, hughd@google.com, stable@kernel.org


The patch titled
     ramfs: fix memleak on no-mmu arch
has been added to the -mm tree.  Its filename is
     ramfs-fix-memleak-on-no-mmu-arch.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ramfs: fix memleak on no-mmu arch
From: Bob Liu <lliubbo@gmail.com>

On no-mmu arch, there is a memleak duirng shmem test.  The cause of this
memleak is ramfs_nommu_expand_for_mapping() added page refcount to 2 which
makes iput() can't free that pages.

The simple test file is like this:
int main(void)
{
	int i;
	key_t k = ftok("/etc", 42);

	for ( i=0; i<100; ++i) {
		int id = shmget(k, 10000, 0644|IPC_CREAT);
		if (id == -1) {
			printf("shmget error\n");
		}
		if(shmctl(id, IPC_RMID, NULL ) == -1) {
			printf("shm  rm error\n");
			return -1;
		}
	}
	printf("run ok...\n");
	return 0;
}

And the result:
root:/> free
             total         used         free       shared      buffers
Mem:         60320        16644        43676            0            0
-/+ buffers:              16644        43676
root:/> shmem
run ok...
root:/> free
             total         used         free       shared      buffers
Mem:         60320        17912        42408            0            0
-/+ buffers:              17912        42408
root:/> shmem
run ok...
root:/> free
             total         used         free       shared      buffers
Mem:         60320        19096        41224            0            0
-/+ buffers:              19096        41224
root:/> shmem
run ok...
root:/> free
             total         used         free       shared      buffers
Mem:         60320        20296        40024            0            0
-/+ buffers:              20296        40024
root:/> shmem
run ok...
root:/> free
             total         used         free       shared      buffers
Mem:         60320        21496        38824            0            0
-/+ buffers:              21496        38824
root:/> shmem
run ok...
root:/> free
             total         used         free       shared      buffers
Mem:         60320        22692        37628            0            0
-/+ buffers:              22692        37628
root:/>

After this patch the test result is:(no memleak anymore)
root:/>
root:/> free
             total         used         free       shared      buffers
Mem:         60320        16580        43740            0            0
-/+ buffers:              16580        43740
root:/> shmem
run ok...
root:/> free
             total         used         free       shared      buffers
Mem:         60320        16668        43652            0            0
-/+ buffers:              16668        43652
root:/> shmem
run ok...
root:/> free
             total         used         free       shared      buffers
Mem:         60320        16668        43652            0            0
-/+ buffers:              16668        43652
root:/> shmem
run ok...
root:/> free
             total         used         free       shared      buffers
Mem:         60320        16668        43652            0            0
-/+ buffers:              16668        43652
root:/> shmem
run ok...
root:/> free
             total         used         free       shared      buffers
Mem:         60320        16668        43652            0            0
-/+ buffers:              16668        43652
root:/> shmem
run ok...
root:/> free
             total         used         free       shared      buffers
Mem:         60320        16668        43652            0            0
-/+ buffers:              16668        43652
root:/>

Signed-off-by: Bob Liu <lliubbo@gmail.com>
Acked-by: Hugh Dickins <hughd@google.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ramfs/file-nommu.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/ramfs/file-nommu.c~ramfs-fix-memleak-on-no-mmu-arch fs/ramfs/file-nommu.c
--- a/fs/ramfs/file-nommu.c~ramfs-fix-memleak-on-no-mmu-arch
+++ a/fs/ramfs/file-nommu.c
@@ -112,6 +112,7 @@ int ramfs_nommu_expand_for_mapping(struc
 		SetPageDirty(page);
 
 		unlock_page(page);
+		put_page(page);
 	}
 
 	return 0;
_

Patches currently in -mm which might be from lliubbo@gmail.com are

ramfs-fix-memleak-on-no-mmu-arch.patch

