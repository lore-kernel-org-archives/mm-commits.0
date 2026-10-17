Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63DA94CF483
	for <mm-commits@vger.kernel.org>; Sat, 17 Oct 2026 02:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792203510; cv=none; b=kZeFKsDNgwnp4Ozx4ZcPKrTUYs9Gy0IMXC5I2/E5MS5xA2PBoteQPLdGkgbhefpCSMNjJbk/Bt/BU07fiCT4t2RKDdnzNJqRbu4zkNYAarkU9Efq+5npAL6YbOlN61ShSOkj+IqWZ3HVMWdetm5/8k4gpXBeXSVphzMcRbS2Ptw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792203510; c=relaxed/simple;
	bh=DGAh50VwTqf/HYOc1caVdJol5N5RMHa7N5bi55HsXEg=;
	h=Date:To:From:Subject:Message-Id; b=NjesJiIy9Cp94TeXlyQSzo3gEyWjhzby95oJuO/XwEi9BUry+LToYEmbx1Ri4RGS7cZR+fixqWcKBhp1KcDKMoRinHhcB+YQKyp284doIjqThYRg5AjUyoYdOs2f2Qthbn6pZ3BcfqFQkJTRdeH+aBTgP1Mun2S3YjsIVfng8tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=l0HqZzsd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="l0HqZzsd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD1EC1F000C4;
	Sat, 17 Oct 2026 02:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792203508;
	bh=x2w3EIRskTgZhzhQbJKkiPlmHAynltuH+cn4lT5N/W0=;
	h=Date:To:From:Subject;
	b=l0HqZzsdXcIIRgz3ihqSUB11ax+hadpUPdPJ/ikNy+vUEs83ozHZtuuljr+zNFTvU
	 cMW6g71oJoKdz/AiS27Em4iVU6aJPI82f6ypLLGBUxsB217/EaqI5yDeRMONveC918
	 mtGQfmrF9kBnyAK9FkZ/8IqIeugKPuTUkM2+6D/Y=
Date: Fri, 16 Oct 2026 19:18:28 -0700
To: mm-commits@vger.kernel.org,treding@nvidia.com,tj@kernel.org,ilpo.jarvinen@linux.intel.com,brads@mainlining.org,bhelgaas@google.com,nickolai@csail.mit.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + resource-report-a-devm_request_resource-conflict-under-the-lock.patch added to mm-unstable branch
Message-Id: <20261017021828.BD1EC1F000C4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: resource: report a devm_request_resource() conflict under the lock
has been added to the -mm mm-unstable branch.  Its filename is
     resource-report-a-devm_request_resource-conflict-under-the-lock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/resource-report-a-devm_request_resource-conflict-under-the-lock.patch

This patch will later appear in the mm-unstable branch at
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
From: Nickolai Zeldovich <nickolai@csail.mit.edu>
Subject: resource: report a devm_request_resource() conflict under the lock
Date: Fri, 16 Oct 2026 10:00:43 -0400

devm_request_resource() calls request_resource_conflict(), which takes
resource_lock, tries to insert the new resource and returns a pointer to
the conflicting resource after dropping the lock.  The error message is
then formatted from that pointer: conflict->name and the %pR argument
read the name, start, end, flags and desc of a resource that nothing
pins any more.  The owner of the conflicting resource may call
release_resource() and free it the moment the lock is dropped.

The conflicting resource normally belongs to another device.  With two
devices whose drivers claim overlapping regions (two PCI host bridges
whose "ranges" windows overlap, two instances of a controller on the
same aperture, or a stale claim an administrator is replacing), the
following interleaving reads freed memory:

  CPU 0: driver B probe                  CPU 1: driver A unbind
  devm_request_resource(devB, root, resB)
    request_resource_conflict()
      write_lock(&resource_lock)
      __request_resource() -> resA
      write_unlock(&resource_lock)
                                         devres_release_all(devA)
                                           devm_resource_release()
                                             release_resource(resA)
                                         put_device() -> kfree(resA)
    dev_err(..., resA->name, resA)        use after free

Both halves are reachable from userspace on any kernel: a write to the
"unbind" file of the driver that holds the region and a write to the
"bind" file of the driver that wants it.  One in-tree path is
drivers/pci/bus.c devm_request_pci_bus_resources(), called from host
bridge probe for every bridge window; the windows are the embedded
struct resource of kzalloc'ed resource_entry objects that
pci_free_resource_list() frees when the other bridge is released.
In the common case the "resource collision" message is garbled; with
the slab object poisoned (CONFIG_SLUB_DEBUG) or reused, formatting
conflict->name oopses, and KASAN reports a slab-use-after-free read in
devm_request_resource().  All of this happens in a probe that is
already failing with -EBUSY.  The window is a few hundred instructions
wide and exists only when two devices actually collide, so the race
has not been observed outside of analysis.

Do the same here: take resource_lock, insert with __request_resource()
and print the diagnostic while the lock still keeps the conflicting
resource in the tree, then drop the lock.  The return values and the
devres handling are unchanged.

The change was built for x86_64 and RISC-V; the resource KUnit tests
pass on both.

Found by formal verification of kernel/resource.c against the kernel
binary.

Link: https://lore.kernel.org/20261016140043.790048-1-nickolai@csail.mit.edu
Fixes: 8d38821cbcf5 ("resources: Add device-managed request/release_resource()")
Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Bradley Morgan <brads@mainlining.org>
Assisted-by: LLM
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Cc: Thierry Reding <treding@nvidia.com>
---

 kernel/resource.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/kernel/resource.c~resource-report-a-devm_request_resource-conflict-under-the-lock
+++ a/kernel/resource.c
@@ -1695,10 +1695,15 @@ int devm_request_resource(struct device
 
 	*ptr = new;
 
-	conflict = request_resource_conflict(root, new);
-	if (conflict) {
+	/* Report a conflict while the lock still keeps it in the tree. */
+	write_lock(&resource_lock);
+	conflict = __request_resource(root, new);
+	if (conflict)
 		dev_err(dev, "resource collision: %pR conflicts with %s %pR\n",
 			new, conflict->name, conflict);
+	write_unlock(&resource_lock);
+
+	if (conflict) {
 		devres_free(ptr);
 		return -EBUSY;
 	}
_

Patches currently in -mm which might be from nickolai@csail.mit.edu are

mm-mlock-use-a-long-for-the-page-count-in-mlock_fixup.patch
mm-truncate-fix-the-zeroing-end-of-pagecache_isize_extended.patch
resource-report-a-devm_request_resource-conflict-under-the-lock.patch

