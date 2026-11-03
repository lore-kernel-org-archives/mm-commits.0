Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793675994;
	b=p+MCJej4Mmo82kAFjzruv2oGNZyYGJC2Nbce/IMW4/q622WZcAzjTNFDAzyKpGjZ/YEc
	 khZBpOuZXsFY2J9df+7T1eD2v/Wlxu7x0LWCUAm6XMyYiHau8CE8LJOluoG806QO1WfKD
	 2Cw8TPQQA8V+5nXWZh1VHH2EORH0I0SV/Uf6giKtaZRJQpW7OFwhPNg+My/pWbqy2bgXV
	 XlW+OxjmYx0yDO9hgbQ7KVxkpAOXQVl98UHpSjM7qD9jK2RtNl3LyX2wwihKm6QYZeq18
	 71Zpsyi5MGSXP7+XEbn1N+w7D7Pd9tPysIayNUn4t7jMFghreBwlV+eNlEMXDhOPK/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793675994;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=xOtaIQ8kqsh+tUhxEaUltXigQ1vdG7JH/8iBOOanVG0=;
	b=M3borzmMWho/8j2Ey8391r+q6HK39NEZuzBH87UwzgGImu1VaWfcKn/FAPLnD3Z7EAq+
	 6n7ah5/ZCjVcm09JwVHH/4qxhRRE2yeNaaNQzrP9a/cKjsAxJ7nzumW3gkcE4xUsXE9aU
	 K96ZOPKHYqCGWmIUpT7dJm4DGG1+ze6KLbgigC0EhjbV+vY3N2JUxq0y9LtSAX/ffgjzm
	 c5vzidgbsSalNOFh8/EzG/EX7VFaNKI49v2FwEGMYOs59FX0doqye9rK9iP+KAAFIsvKp
	 Ttgqn1Wyqu8Lm9hHtJJS+XSK3k65Nrte4QCQT7NZaw2eraxhvVAbsc0aeQDFTADgvng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=najh+SrD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1462606A329;
	Tue,  3 Nov 2026 03:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=najh+SrD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F9DD1F000C1;
	Tue,  3 Nov 2026 03:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793675993;
	bh=xOtaIQ8kqsh+tUhxEaUltXigQ1vdG7JH/8iBOOanVG0=;
	h=Date:To:From:Subject;
	b=najh+SrDOvMyazkaJWxgWfV1Jj1IIRdV0IiIDAlWZQLew+0mL7x1DogvcoklvInC/
	 fKxrRxPc3Q+kHT3BZt30qBhuXFq3eWQZFhq/18WrqTlz1QRXSxKIlypHmTkgh+1Tka
	 6ak/KO2P0gG6UmSc78Fz85e1206ukxsIPH2kS8CA=
Date: Mon, 02 Nov 2026 19:19:52 -0800
To: mm-commits@vger.kernel.org,sunil.mushran@oracle.com,
	stable@vger.kernel.org,mark@fasheh.com,kuba@kernel.org,kees@kernel.org,
	joseph.qi@linux.alibaba.com,jlbec@evilplan.org,jjzuming@gmail.com,
	heming.zhao@suse.com,baijiaju1990@gmail.com,zzzccc427@gmail.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-hotfixes-stable] ocfs2-cluster-unlink-socket-containers-before-releasing-resources.patch removed from -mm tree
Message-Id: <20261103031953.4F9DD1F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: ocfs2/cluster: unlink socket containers before releasing resources
has been removed from the -mm tree.  Its filename was
     ocfs2-cluster-unlink-socket-containers-before-releasing-resources.patch

This patch was dropped because it was merged into the mm-nonmm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


