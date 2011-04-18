From: akpm@linux-foundation.org
Subject: [merged] ramfs-fix-memleak-on-no-mmu-arch.patch removed from -mm tree
Date: Mon, 18 Apr 2011 11:03:16 -0700
Message-ID: <201104181759.p3IHxSrA016156@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47885 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756220Ab1DRSAG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Apr 2011 14:00:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lliubbo@gmail.com, dhowells@redhat.com, hughd@google.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     ramfs: fix memleak on no-mmu arch
has been removed from the -mm tree.  Its filename was
     ramfs-fix-memleak-on-no-mmu-arch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

