Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12176C4338F
	for <mm-commits@archiver.kernel.org>; Tue, 27 Jul 2021 20:25:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EAAB860FC0
	for <mm-commits@archiver.kernel.org>; Tue, 27 Jul 2021 20:25:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232306AbhG0UZV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 27 Jul 2021 16:25:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:47134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232214AbhG0UZU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 27 Jul 2021 16:25:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A755860F9E;
        Tue, 27 Jul 2021 20:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1627417520;
        bh=tJYV9sZusEo5pildns1ZLqGwXnuL77wixu0O5Kdb9eQ=;
        h=Date:From:To:Subject:From;
        b=Rf+WN0+2v7bao+7Q2ULG33SlfjAnbHS44m2j4+sFJvuPgfeJL2klGX/9oxTzPvLbP
         OecfAKm5KJajswmERVVMu90L5eBJHnXb1bTG/n1SFMSk63vlYHwnb6UYgvFzdFtetX
         b9w3H+08rhd/2BBxPjfiIMzVpMItI+7RSfTuGqCw=
Date:   Tue, 27 Jul 2021 13:25:19 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, will@kernel.org,
        viro@zeniv.linux.org.uk, tsbogend@alpha.franken.de,
        tglx@linutronix.de, paulus@samba.org, mpe@ellerman.id.au,
        mingo@redhat.com, James.Bottomley@HansenPartnership.com,
        hpa@zytor.com, hch@lst.de, hch@infradead.org, hca@linux.ibm.com,
        gor@linux.ibm.com, feng.tang@intel.com, ebiederm@xmission.com,
        deller@gmx.de, davem@davemloft.net, catalin.marinas@arm.com,
        bp@alien8.de, borntraeger@de.ibm.com, benh@kernel.crashing.org,
        arnd@arndb.de
Subject:  + mm-simplify-compat-numa-syscalls.patch added to -mm tree
Message-ID: <20210727202519.UTGHD%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: simplify compat numa syscalls
has been added to the -mm tree.  Its filename is
     mm-simplify-compat-numa-syscalls.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-simplify-compat-numa-syscalls.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-simplify-compat-numa-syscalls.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: mm: simplify compat numa syscalls

The compat implementations for mbind, get_mempolicy, set_mempolicy and
migrate_pages are just there to handle the subtly different layout of
bitmaps on 32-bit hosts.

The compat implementation however lacks some of the checks that are
present in the native one, in particular for checking that the extra bits
are all zero when user space has a larger mask size than the kernel. 
Worse, those extra bits do not get cleared when copying in or out of the
kernel, which can lead to incorrect data as well.

Unify the implementation to handle the compat bitmap layout directly in
the get_nodes() and copy_nodes_to_user() helpers.  Splitting out the
get_bitmap() helper from get_nodes() also helps readability of the native
case.

On x86, two additional problems are addressed by this: compat tasks can
pass a bitmap at the end of a mapping, causing a fault when reading across
the page boundary for a 64-bit word.  x32 tasks might also run into
problems with get_mempolicy corrupting data when an odd number of 32-bit
words gets passed.

On parisc the migrate_pages() system call apparently had the wrong calling
convention, as big-endian architectures expect the words inside of a
bitmap to be swapped.  This is not a problem though since parisc has no
NUMA support.

Link: https://lkml.kernel.org/r/20210727144859.4150043-5-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Feng Tang <feng.tang@intel.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compat.h |   17 ++-
 mm/mempolicy.c         |  175 ++++++++++++---------------------------
 2 files changed, 63 insertions(+), 129 deletions(-)

--- a/include/linux/compat.h~mm-simplify-compat-numa-syscalls
+++ a/include/linux/compat.h
@@ -395,14 +395,6 @@ struct compat_kexec_segment;
 struct compat_mq_attr;
 struct compat_msgbuf;
 
-#define BITS_PER_COMPAT_LONG    (8*sizeof(compat_long_t))
-
-#define BITS_TO_COMPAT_LONGS(bits) DIV_ROUND_UP(bits, BITS_PER_COMPAT_LONG)
-
-long compat_get_bitmap(unsigned long *mask, const compat_ulong_t __user *umask,
-		       unsigned long bitmap_size);
-long compat_put_bitmap(compat_ulong_t __user *umask, unsigned long *mask,
-		       unsigned long bitmap_size);
 void copy_siginfo_to_external32(struct compat_siginfo *to,
 		const struct kernel_siginfo *from);
 int copy_siginfo_from_user32(kernel_siginfo_t *to,
@@ -976,6 +968,15 @@ static inline bool in_compat_syscall(voi
 
 #endif /* CONFIG_COMPAT */
 
+#define BITS_PER_COMPAT_LONG    (8*sizeof(compat_long_t))
+
+#define BITS_TO_COMPAT_LONGS(bits) DIV_ROUND_UP(bits, BITS_PER_COMPAT_LONG)
+
+long compat_get_bitmap(unsigned long *mask, const compat_ulong_t __user *umask,
+		       unsigned long bitmap_size);
+long compat_put_bitmap(compat_ulong_t __user *umask, unsigned long *mask,
+		       unsigned long bitmap_size);
+
 /*
  * Some legacy ABIs like the i386 one use less than natural alignment for 64-bit
  * types, and will need special compat treatment for that.  Most architectures
--- a/mm/mempolicy.c~mm-simplify-compat-numa-syscalls
+++ a/mm/mempolicy.c
@@ -1362,16 +1362,33 @@ mpol_out:
 /*
  * User space interface with variable sized bitmaps for nodelists.
  */
+static int get_bitmap(unsigned long *mask, const unsigned long __user *nmask,
+		      unsigned long maxnode)
+{
+	unsigned long nlongs = BITS_TO_LONGS(maxnode);
+	int ret;
+
+	if (in_compat_syscall())
+		ret = compat_get_bitmap(mask,
+					(const compat_ulong_t __user *)nmask,
+					maxnode);
+	else
+		ret = copy_from_user(mask, nmask,
+				     nlongs * sizeof(unsigned long));
+
+	if (ret)
+		return -EFAULT;
+
+	if (maxnode % BITS_PER_LONG)
+		mask[nlongs - 1] &= (1UL << (maxnode % BITS_PER_LONG)) - 1;
+
+	return 0;
+}
 
 /* Copy a node mask from user space. */
 static int get_nodes(nodemask_t *nodes, const unsigned long __user *nmask,
 		     unsigned long maxnode)
 {
-	unsigned long k;
-	unsigned long t;
-	unsigned long nlongs;
-	unsigned long endmask;
-
 	--maxnode;
 	nodes_clear(*nodes);
 	if (maxnode == 0 || !nmask)
@@ -1379,49 +1396,29 @@ static int get_nodes(nodemask_t *nodes,
 	if (maxnode > PAGE_SIZE*BITS_PER_BYTE)
 		return -EINVAL;
 
-	nlongs = BITS_TO_LONGS(maxnode);
-	if ((maxnode % BITS_PER_LONG) == 0)
-		endmask = ~0UL;
-	else
-		endmask = (1UL << (maxnode % BITS_PER_LONG)) - 1;
-
 	/*
 	 * When the user specified more nodes than supported just check
-	 * if the non supported part is all zero.
-	 *
-	 * If maxnode have more longs than MAX_NUMNODES, check
-	 * the bits in that area first. And then go through to
-	 * check the rest bits which equal or bigger than MAX_NUMNODES.
-	 * Otherwise, just check bits [MAX_NUMNODES, maxnode).
+	 * if the non supported part is all zero, one word at a time,
+	 * starting at the end.
 	 */
-	if (nlongs > BITS_TO_LONGS(MAX_NUMNODES)) {
-		for (k = BITS_TO_LONGS(MAX_NUMNODES); k < nlongs; k++) {
-			if (get_user(t, nmask + k))
-				return -EFAULT;
-			if (k == nlongs - 1) {
-				if (t & endmask)
-					return -EINVAL;
-			} else if (t)
-				return -EINVAL;
-		}
-		nlongs = BITS_TO_LONGS(MAX_NUMNODES);
-		endmask = ~0UL;
-	}
-
-	if (maxnode > MAX_NUMNODES && MAX_NUMNODES % BITS_PER_LONG != 0) {
-		unsigned long valid_mask = endmask;
+	while (maxnode > MAX_NUMNODES) {
+		unsigned long bits = min_t(unsigned long, maxnode, BITS_PER_LONG);
+		unsigned long t;
 
-		valid_mask &= ~((1UL << (MAX_NUMNODES % BITS_PER_LONG)) - 1);
-		if (get_user(t, nmask + nlongs - 1))
+		if (get_bitmap(&t, &nmask[maxnode / BITS_PER_LONG], bits))
 			return -EFAULT;
-		if (t & valid_mask)
+
+		if (maxnode - bits >= MAX_NUMNODES) {
+			maxnode -= bits;
+		} else {
+			maxnode = MAX_NUMNODES;
+			t &= ~((1UL << (MAX_NUMNODES % BITS_PER_LONG)) - 1);
+		}
+		if (t)
 			return -EINVAL;
 	}
 
-	if (copy_from_user(nodes_addr(*nodes), nmask, nlongs*sizeof(unsigned long)))
-		return -EFAULT;
-	nodes_addr(*nodes)[nlongs-1] &= endmask;
-	return 0;
+	return get_bitmap(nodes_addr(*nodes), nmask, maxnode);
 }
 
 /* Copy a kernel node mask to user space */
@@ -1430,6 +1427,10 @@ static int copy_nodes_to_user(unsigned l
 {
 	unsigned long copy = ALIGN(maxnode-1, 64) / 8;
 	unsigned int nbytes = BITS_TO_LONGS(nr_node_ids) * sizeof(long);
+	bool compat = in_compat_syscall();
+
+	if (compat)
+		nbytes = BITS_TO_COMPAT_LONGS(nr_node_ids) * sizeof(compat_long_t);
 
 	if (copy > nbytes) {
 		if (copy > PAGE_SIZE)
@@ -1438,6 +1439,11 @@ static int copy_nodes_to_user(unsigned l
 			return -EFAULT;
 		copy = nbytes;
 	}
+
+	if (compat)
+		return compat_put_bitmap((compat_ulong_t __user *)mask,
+					 nodes_addr(*nodes), maxnode);
+
 	return copy_to_user(mask, nodes_addr(*nodes), copy) ? -EFAULT : 0;
 }
 
@@ -1649,72 +1655,22 @@ COMPAT_SYSCALL_DEFINE5(get_mempolicy, in
 		       compat_ulong_t, maxnode,
 		       compat_ulong_t, addr, compat_ulong_t, flags)
 {
-	long err;
-	unsigned long __user *nm = NULL;
-	unsigned long nr_bits, alloc_size;
-	DECLARE_BITMAP(bm, MAX_NUMNODES);
-
-	nr_bits = min_t(unsigned long, maxnode-1, nr_node_ids);
-	alloc_size = ALIGN(nr_bits, BITS_PER_LONG) / 8;
-
-	if (nmask)
-		nm = compat_alloc_user_space(alloc_size);
-
-	err = kernel_get_mempolicy(policy, nm, nr_bits+1, addr, flags);
-
-	if (!err && nmask) {
-		unsigned long copy_size;
-		copy_size = min_t(unsigned long, sizeof(bm), alloc_size);
-		err = copy_from_user(bm, nm, copy_size);
-		/* ensure entire bitmap is zeroed */
-		err |= clear_user(nmask, ALIGN(maxnode-1, 8) / 8);
-		err |= compat_put_bitmap(nmask, bm, nr_bits);
-	}
-
-	return err;
+	return kernel_get_mempolicy(policy, (unsigned long __user *)nmask,
+				    maxnode, addr, flags);
 }
 
 COMPAT_SYSCALL_DEFINE3(set_mempolicy, int, mode, compat_ulong_t __user *, nmask,
 		       compat_ulong_t, maxnode)
 {
-	unsigned long __user *nm = NULL;
-	unsigned long nr_bits, alloc_size;
-	DECLARE_BITMAP(bm, MAX_NUMNODES);
-
-	nr_bits = min_t(unsigned long, maxnode-1, MAX_NUMNODES);
-	alloc_size = ALIGN(nr_bits, BITS_PER_LONG) / 8;
-
-	if (nmask) {
-		if (compat_get_bitmap(bm, nmask, nr_bits))
-			return -EFAULT;
-		nm = compat_alloc_user_space(alloc_size);
-		if (copy_to_user(nm, bm, alloc_size))
-			return -EFAULT;
-	}
-
-	return kernel_set_mempolicy(mode, nm, nr_bits+1);
+	return kernel_set_mempolicy(mode, (unsigned long __user *)nmask, maxnode);
 }
 
 COMPAT_SYSCALL_DEFINE6(mbind, compat_ulong_t, start, compat_ulong_t, len,
 		       compat_ulong_t, mode, compat_ulong_t __user *, nmask,
 		       compat_ulong_t, maxnode, compat_ulong_t, flags)
 {
-	unsigned long __user *nm = NULL;
-	unsigned long nr_bits, alloc_size;
-	nodemask_t bm;
-
-	nr_bits = min_t(unsigned long, maxnode-1, MAX_NUMNODES);
-	alloc_size = ALIGN(nr_bits, BITS_PER_LONG) / 8;
-
-	if (nmask) {
-		if (compat_get_bitmap(nodes_addr(bm), nmask, nr_bits))
-			return -EFAULT;
-		nm = compat_alloc_user_space(alloc_size);
-		if (copy_to_user(nm, nodes_addr(bm), alloc_size))
-			return -EFAULT;
-	}
-
-	return kernel_mbind(start, len, mode, nm, nr_bits+1, flags);
+	return kernel_mbind(start, len, mode, (unsigned long __user *)nmask,
+			    maxnode, flags);
 }
 
 COMPAT_SYSCALL_DEFINE4(migrate_pages, compat_pid_t, pid,
@@ -1722,32 +1678,9 @@ COMPAT_SYSCALL_DEFINE4(migrate_pages, co
 		       const compat_ulong_t __user *, old_nodes,
 		       const compat_ulong_t __user *, new_nodes)
 {
-	unsigned long __user *old = NULL;
-	unsigned long __user *new = NULL;
-	nodemask_t tmp_mask;
-	unsigned long nr_bits;
-	unsigned long size;
-
-	nr_bits = min_t(unsigned long, maxnode - 1, MAX_NUMNODES);
-	size = ALIGN(nr_bits, BITS_PER_LONG) / 8;
-	if (old_nodes) {
-		if (compat_get_bitmap(nodes_addr(tmp_mask), old_nodes, nr_bits))
-			return -EFAULT;
-		old = compat_alloc_user_space(new_nodes ? size * 2 : size);
-		if (new_nodes)
-			new = old + size / sizeof(unsigned long);
-		if (copy_to_user(old, nodes_addr(tmp_mask), size))
-			return -EFAULT;
-	}
-	if (new_nodes) {
-		if (compat_get_bitmap(nodes_addr(tmp_mask), new_nodes, nr_bits))
-			return -EFAULT;
-		if (new == NULL)
-			new = compat_alloc_user_space(size);
-		if (copy_to_user(new, nodes_addr(tmp_mask), size))
-			return -EFAULT;
-	}
-	return kernel_migrate_pages(pid, nr_bits + 1, old, new);
+	return kernel_migrate_pages(pid, maxnode,
+				    (const unsigned long __user *)old_nodes,
+				    (const unsigned long __user *)new_nodes);
 }
 
 #endif /* CONFIG_COMPAT */
_

Patches currently in -mm which might be from arnd@arndb.de are

kexec-move-locking-into-do_kexec_load.patch
kexec-avoid-compat_alloc_user_space.patch
mm-simplify-compat_sys_move_pages.patch
mm-simplify-compat-numa-syscalls.patch
compat-remove-some-compat-entry-points.patch
arch-remove-compat_alloc_user_space.patch

