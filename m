Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E12436F8F3
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780027638; cv=none; b=ULlUZ0kR8adiEUsYzMzUsqpTe7bABIHl5WiWCsF/SSowy6sS7xseakAkZFJ9EJfDr55xKGPN0mnWJnbzCDNkfXtx7ylL94LpOUrbkopHAdK/F1iVo+KVH1tRtqRfkzQAUnbMOEiir8rdTlQmCeD/u48ASGPHlbg+Epp/uAuDE+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780027638; c=relaxed/simple;
	bh=yltfHTRG8eLRdSHIzfV9GrcoOQyYavYywmPKXWtNU7o=;
	h=Date:To:From:Subject:Message-Id; b=TLZFe/GkeRC0hHFUyr3kCNoxpyAw9OHyVhLZNM0i0Qptr4jaFEP0Riw2Kn2ve/T9I+FmEP5ilZxjlIPE1ktO67GLnMMmV56MNXIUyAd/94xr0bB0gS7KPcJz0nB7/YmOYdLvVeWLVeBLehNZkdv9oQ9Eq0R7djBGOIbYcWMqpZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LNCQDdSB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LNCQDdSB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 182351F0089A;
	Fri, 29 May 2026 04:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780027629;
	bh=6Mkyt+BSytFC+EIu1vmpQmTdJjbjUbFE1KGsPsoO1zw=;
	h=Date:To:From:Subject;
	b=LNCQDdSBinn2mUe8V1yggxZviNh7F7SaBoJTj84TB//TUG1ScdnoNZp1iRSghAaM1
	 YsWCL0A24gXnDBroZBqOtV7x02tJB5GZmXqX4UEX/AitbrOh+s26nd2gD5k8WV3n5W
	 PvvgVnyXdjScOKUV4d2ymuITou2I65qL2fGQa2i8=
Date: Thu, 28 May 2026 21:07:08 -0700
To: mm-commits@vger.kernel.org,vishal.l.verma@intel.com,jonathan.cameron@huawei.com,dave.jiang@intel.com,dan.j.williams@intel.com,benjamin.cheatham@amd.com,alison.schofield@intel.com,dave@stgolabs.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] dax-kmem-account-for-partial-dis-contiguous-resource-upon-removal.patch removed from -mm tree
Message-Id: <20260529040709.182351F0089A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: dax/kmem: account for partial discontiguous resource upon removal
has been removed from the -mm tree.  Its filename was
     dax-kmem-account-for-partial-dis-contiguous-resource-upon-removal.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: dax/kmem: account for partial discontiguous resource upon removal
Date: Mon, 23 Feb 2026 12:15:16 -0800

When dev_dax_kmem_probe() partially succeeds (at least one range is
mapped) but a subsequent range fails request_mem_region() or
add_memory_driver_managed(), the probe silently continues, ultimately
returning success, but with the corresponding range resource NULL'ed out.

dev_dax_kmem_remove() iterates over all dax_device ranges regardless of if
the underlying resource exists.  When remove_memory() is called later, it
returns 0 because the memory was never added which causes
dev_dax_kmem_remove() to incorrectly assume the (nonexistent) resource can
be removed and attempts cleanup on a NULL pointer.

Fix this by skipping these ranges altogether, noting that these cases are
considered success, such that the cleanup is still reached when all
actually-added ranges are successfully removed.

Link: https://lore.kernel.org/20260223201516.1517657-1-dave@stgolabs.net
Fixes: 60e93dc097f7 ("device-dax: add dis-contiguous resource support")
Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>
Reviewed-by: Ben Cheatham <benjamin.cheatham@amd.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dax/kmem.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/dax/kmem.c~dax-kmem-account-for-partial-dis-contiguous-resource-upon-removal
+++ a/drivers/dax/kmem.c
@@ -227,6 +227,12 @@ static void dev_dax_kmem_remove(struct d
 		if (rc)
 			continue;
 
+		/* range was never added during probe */
+		if (!data->res[i]) {
+			success++;
+			continue;
+		}
+
 		rc = remove_memory(range.start, range_len(&range));
 		if (rc == 0) {
 			remove_resource(data->res[i]);
_

Patches currently in -mm which might be from dave@stgolabs.net are


