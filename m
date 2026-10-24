Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832527;
	b=v3UqkC180y5F9vctuvpNs171iTJA/+w9iswqlB3t3QIEIEh9OEVRzv13O2hnswqkSTz/
	 Uam8Gi3Qak34kKlRtFSrWy8xINpEUtb4yVLTScJmfwhurpSeEwiGbm6AqSOZV8GVF/D0h
	 LZVTz8J/nvNXTBXlIfa07b3wfeZbSV8mtwYFumjGV0iQjomiDKLskQar25Zq5EuzHjX9L
	 PGhtinpH/PANqvQNJmIFe+54IMHXLDaCC979tNk4sCQWSvZyz+JW16fgPS7HljzVfYITj
	 vSNmAkKmxsjsuMV8tPhMoOEo7Kh3rASSKZJ/+PjJqt/5BTcCOzCzouvfatepXbAGNZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832527;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=0QGVPx+14F9UmwJlUnxF0uhlWny9YKPSQZYXqMQ5NGQ=;
	b=KLq/sN7CrRmJLkm6xYvmnsWmaH93EqdAoE/LWN+0kC+qTCY0LSNN2gGiMOYhvEP5b7t9
	 YBfs/CS9ZdWB4YmASwd638HGRHeRVQ5+SnrdVm8KGrlz4Uvp+Kr90LOfDBnRT/OqhyZZG
	 AN1b25oiTJsB9ZPkmXY91mpv62ZCzOUcKBt22yscvLkwF1RsBEUBxM3IpuTBIkc9PYsEm
	 GtTUR59CtaoRXuamSHO+9G8fJxxAjRjOFGJ1vYUbMuKUjYB39fWMo4cOw7YoA1Jq43J+i
	 edbnjVTkbgpD98rTe05oq7+RTYSOWLMCEIwHgXY2TgWa4ep+c1CGxRVgu2ZzUK0qXDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=rhKeUWqr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76877606A325;
	Sat, 24 Oct 2026 09:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=rhKeUWqr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 418AA1F01825;
	Sat, 24 Oct 2026 09:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832527;
	bh=0QGVPx+14F9UmwJlUnxF0uhlWny9YKPSQZYXqMQ5NGQ=;
	h=Date:To:From:Subject;
	b=rhKeUWqrMfB3hBO2repTkyH42/2i4VkCY+5EbnUknXn4e3xl4Wn/fxHm4Lp1T2Di5
	 uHnNgroqYnxS9ERW2+pxleDnPMO9Cfy650Tl1yy3VWm7LiwsAsUXrxlMY/9aAYXHTo
	 wLwayy/KpjVV41lZOclVfEspCc2Liforga3yl3JU=
Date: Sat, 24 Oct 2026 02:02:06 -0700
To: mm-commits@vger.kernel.org,treding@nvidia.com,tj@kernel.org,stable@vger.kernel.org,ilpo.jarvinen@linux.intel.com,brads@mainlining.org,bhelgaas@google.com,nickolai@csail.mit.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] resource-report-a-devm_request_resource-conflict-under-the-lock.patch removed from -mm tree
Message-Id: <20261024090207.418AA1F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: resource: report a devm_request_resource() conflict under the lock
has been removed from the -mm tree.  Its filename was
     resource-report-a-devm_request_resource-conflict-under-the-lock.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Cc: <stable@vger.kernel.org>
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

xarray-clear-the-new-heads-parent-before-freeing-the-old-head.patch
mm-vmalloc-read-vm_map_ram-block-regions-from-the-requested-offset.patch

