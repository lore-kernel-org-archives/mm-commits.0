Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793342308;
	b=l6HOfRLtQsTMhDAxj2FfFd1Kwv6VO4VUwqT38n0u9nS2IkjeLXENvhTiAzctbx0iuuqS
	 8UAcOsMFTxpH+yjTuoaxE65r86TNQ5K8di/H4+DGZCO51JjbSuX2ewoiYwzLjF0U97h+S
	 R0TwtZYlpv8N2yO/dsn6A0PWK5moltPu22O0SFDriwBzcyDaycKGxNyF/KyRi0Y+9NO/w
	 FlPlhjjV+FlfgkYLQ9rb9FK0Ze4e4pLRb8i+b7CLs1PRSR/m8KaeLq3xDoCuOhBh3t0fT
	 xauG1rvdAwddS4Bg2Bxys5rR7jjkLl7eYBiHbPbWXj2dvgbWTQILUy/+R5Y8PL2F6YQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793342308;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=dEIhOBrdjRaN4SymHNFrzFpPir2led2H84wobob8dvc=;
	b=hmymg9iwWff3pBvWRVoL8aAYNEfqkEz3qs/hqrNvA2ZmA79pXYTJAn3wzezxjMMDXu6R
	 pQaa184pJesBJXmpu5tENoJoQviGTuq3K0leUchkm36poNtzxXnYtvZLP2URQYQZk5j+u
	 Iig1Gu0yQF4Ub7aCPvYRYTMR4pR01MeHKehkLyFIlOMTdwBe6Us9vJT4E4JaZDuLMfzFT
	 sY0LfBMnxUFsBq7AhTqyOxhJowdyGjfpu7XKmGIpBdzYS4A10ias4zkMouB9GEEbDtYTX
	 cDl/N8X0mc8IFB06vzumaCeacN0Mq421EaxjolC7zZ/GGyPDw8Kjo9fBcLIoR+HT2vw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ejcObEZg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48D56606A31D;
	Fri, 30 Oct 2026 06:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ejcObEZg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A05DD1F0093A;
	Fri, 30 Oct 2026 06:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793342307;
	bh=dEIhOBrdjRaN4SymHNFrzFpPir2led2H84wobob8dvc=;
	h=Date:To:From:Subject;
	b=ejcObEZgbfB4A6gmGdtqrQxDbGPQ605gDJqpOPuz21RL93UTHxRTmWrrh1DJz95Mj
	 TjijUoGbbdz8c/op38b1Xu9tVLtRsSZJx78ioHAa6iTb0jPLUsFudzKwYJ1hr6PkYg
	 a+meJa6shsuxUfEWP2ruhCbah/zF5NgQZenjdOl8=
Date: Thu, 29 Oct 2026 23:38:27 -0700
To: mm-commits@vger.kernel.org,sunil.mushran@oracle.com,
	stable@vger.kernel.org,mark@fasheh.com,kuba@kernel.org,kees@kernel.org,
	joseph.qi@linux.alibaba.com,jlbec@evilplan.org,jjzuming@gmail.com,
	heming.zhao@suse.com,baijiaju1990@gmail.com,zzzccc427@gmail.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-cluster-unlink-socket-containers-before-releasing-resources.patch added to mm-nonmm-hotfixes-unstable branch
Message-Id: <20261030063827.A05DD1F0093A@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: ocfs2/cluster: unlink socket containers before releasing resources
has been added to the -mm mm-nonmm-hotfixes-unstable branch.  Its filename is
     ocfs2-cluster-unlink-socket-containers-before-releasing-resources.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-cluster-unlink-socket-containers-before-releasing-resources.patch

This patch will later appear in the mm-nonmm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Cen Zhang <zzzccc427@gmail.com>
Subject: ocfs2/cluster: unlink socket containers before releasing resources
Date: Tue, 13 Oct 2026 23:34:46 +0800

A socket container's node and socket must remain alive while the
container is on sock_containers. The debugfs formatter reads sc_node
and sc_sock under o2net_debug_lock without taking their references, but
sc_kref_release() releases both before taking that lock to unlink the
container.

With CONFIG_DEBUG_FS enabled, a synchronous sender can retain its last
socket-container reference after o2net_disconnect_node() has detached
the connection and flushed o2net_wq. The caller runs outside that
workqueue. After the sender removes its configfs dependency, node
removal can proceed without waiting for the sender's final sc_put():

  Sender (final sc_put)    Configfs rmdir        Debugfs reader
  --------------------    --------------        --------------
  o2nm_undepend_item()
                          Drop node item refs
  o2nm_node_put()
    [node can be freed]
                                               sc_seq_show()
                                                 Lock debug lock
                                                 Read sc_node->nd_name
                                                 Unlock debug lock
  sc_node = NULL
  o2net_debug_del_sc()

The earlier socket release has a similar window. The container is
still selectable while its socket has been released and sc_sock has
not yet been cleared:

  Sender (final sc_put)                       Debugfs reader
  --------------------                       --------------
  sock_release(sc->sc_sock)
    [socket can be freed]
                                             sc_seq_show()
                                               Lock debug lock
                                               Read sc_sock->sk fields
                                               Unlock debug lock
  sc_sock = NULL
  ...
  o2net_debug_del_sc()

Move o2net_debug_del_sc() before releasing either resource. Unlinking
under the existing debug lock waits for an active formatter to finish
and prevents later readers from selecting the container. This covers
both socket fields and node fields, including nd_num in the stats
formatter.

KASAN report as below:

    BUG: KASAN: slab-use-after-free in string+0x42b/0x470
    Read of size 1 at addr ffff88810f56fc90 by task python3/506

    CPU: 0 UID: 0 PID: 506 Comm: python3 Not tainted 7.3.0-rc4-next-20260921-pmb-ocfs2-functional-v1+ #1 PREEMPT(lazy)
    Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
    Call Trace:
     <TASK>
     dump_stack_lvl+0x93/0xd0
     print_report+0xce/0x630
     kasan_report+0xe0/0x110
     string+0x42b/0x470
     vsnprintf+0x330/0x1110
     seq_printf+0x1a8/0x260
     sc_seq_show+0x604/0x9f0
     seq_read_iter+0x480/0x1110
     seq_read+0x362/0x5a0
     full_proxy_read+0x11f/0x180
     vfs_read+0x1a0/0xc20
     ksys_read+0x111/0x200
     do_syscall_64+0x114/0x620
     entry_SYSCALL_64_after_hwframe+0x77/0x7f

(User register dump omitted.)

     </TASK>

    Allocated by task 497:
     kasan_save_stack+0x33/0x60
     kasan_save_track+0x14/0x30
     __kasan_kmalloc+0xaa/0xb0
     __kmalloc_cache_noprof+0x28d/0x610
     o2nm_node_group_make_item+0xea/0x1a0
     configfs_mkdir+0x762/0xca0
     vfs_mkdir+0x399/0x7e0
     filename_mkdirat+0x129/0x450
     __x64_sys_mkdir+0x70/0xa0
     do_syscall_64+0x114/0x620
     entry_SYSCALL_64_after_hwframe+0x77/0x7f

    Freed by task 505:
     kasan_save_stack+0x33/0x60
     kasan_save_track+0x14/0x30
     kasan_save_free_info+0x3b/0x60
     __kasan_slab_free+0x5f/0x80
     kfree+0x308/0x580
     config_item_cleanup+0x14b/0x230
     config_item_put+0x79/0x90
     sc_put+0x454/0x6e0
     o2net_send_message_vec+0x63d/0x1560
     o2net_send_message+0xa6/0xe0
     validation_send_write+0x17f/0x1d0
     full_proxy_write+0x11f/0x180
     vfs_write+0x25a/0x1010
     ksys_write+0x111/0x200
     do_syscall_64+0x114/0x620
     entry_SYSCALL_64_after_hwframe+0x77/0x7f

    The buggy address belongs to the object at ffff88810f56fc00
     which belongs to the cache kmalloc-512 of size 512
    The buggy address is located 144 bytes inside of
     freed 512-byte region [ffff88810f56fc00, ffff88810f56fe00)

(Page and shadow-memory dumps omitted.)

Link: https://lore.kernel.org/pm-ocfs2-objects-candidate-0065-v6-3090153fd7cacb810214@gmail.com
Fixes: 2309e9e040fe ("ocfs2/net: Add debug interface to o2net")
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Assisted-by: LLM
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Sunil Mushran <sunil.mushran@oracle.com>
Cc: Jia-Ju Bai <baijiaju1990@gmail.com>
Cc: <jjzuming@gmail.com>
Cc: <stable@vger.kernel.org>
---

 fs/ocfs2/cluster/tcp.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/ocfs2/cluster/tcp.c~ocfs2-cluster-unlink-socket-containers-before-releasing-resources
+++ a/fs/ocfs2/cluster/tcp.c
@@ -393,6 +393,9 @@ static void sc_kref_release(struct kref
 
 	sclog(sc, "releasing\n");
 
+	/* Unlink before freeing anything the debugfs readers dereference. */
+	o2net_debug_del_sc(sc);
+
 	if (sc->sc_sock) {
 		sock_release(sc->sc_sock);
 		sc->sc_sock = NULL;
@@ -402,8 +405,6 @@ static void sc_kref_release(struct kref
 	o2nm_node_put(sc->sc_node);
 	sc->sc_node = NULL;
 
-	o2net_debug_del_sc(sc);
-
 	if (sc->sc_page)
 		__free_page(sc->sc_page);
 	kfree(sc);
_

Patches currently in -mm which might be from zzzccc427@gmail.com are

ocfs2-validate-move-extents-against-a-stable-eof.patch
ocfs2-keep-locking_state-within-the-cluster-connection-lifetime.patch
ocfs2-dlm-serialize-migration-mle-cleanup-on-failure.patch
ocfs2-stop-recovery-before-shutting-down-local-allocators.patch
ocfs2-cluster-unlink-socket-containers-before-releasing-resources.patch
ocfs2-wait-for-filecheck-kobject-release-after-a-failed-add.patch
ocfs2-cache-the-mount-context-for-dentry-lock-callbacks.patch

