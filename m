Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F58B3A7F70
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 02:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068040; cv=none; b=X5tOZ6BLExx9Pd6OCFR4GJbT8/AamfXcF48/SBjnAmDtQJ6obDw8UMriuKGfS/TmbTNROkizIeNjozlwIntcOE8Xq/XeZ0TZzta/1Xz/w1IIV00c4yqVN3gxpZrAYteRnAJVH09bzINCxg/rWl6Od5DTOxsnpPweZcGJy+Img1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068040; c=relaxed/simple;
	bh=G4BKHaygh0V1CL6TUV923kYAY4jxNIV1cjOFnT+Kp3Q=;
	h=Date:To:From:Subject:Message-Id; b=Sh/RPanjjyyGMiTYtVwUmwn4MvjuYhnTdCgHhgoNPbMM2RP7rlIJBTdpOgHp+TLYnMUdDsVNmWUbmYGC5u3awsIUM7qGIwOATrvrqat4ev9j77o5eI3UfZc6XlxGJgqnCLwYcXQJq6k91g+dMDi07u2BZsESw6gEhjmJfKulnmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nUVpprBH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nUVpprBH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EE381F00A3A;
	Fri,  7 Aug 2026 02:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068036;
	bh=w1UZOsi6FKKwtoq6hptLDk0o05rVsoejl0ngqeiIgF8=;
	h=Date:To:From:Subject;
	b=nUVpprBHKxLEnMtWMSChkcx23QbRVAdb/8/7Et8iAAHZ1voG834yHyqoPEf2n2t5m
	 dNReHT8oNo5DAI123sACugyIqDh982O4+ZhHaqs32zie+onDfU9IH9X8hn1V35dHSN
	 0nlub4Fv8Qfme1hK/7NYkzHX0cdEybzIJhpTxR6w=
Date: Thu, 06 Aug 2026 19:00:36 -0700
To: mm-commits@vger.kernel.org,vishal.l.verma@intel.com,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,rafael@kernel.org,pankaj.gupta@amd.com,osalvador@suse.de,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,hare@suse.de,gregkh@linuxfoundation.org,david@kernel.org,dave.jiang@intel.com,dakr@kernel.org,alison.schofield@intel.com,gourry@gourry.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] dax-kmem-resolve-default-online-type-at-probe-time.patch removed from -mm tree
Message-Id: <20260807020036.6EE381F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: dax/kmem: resolve default online type at probe time
has been removed from the -mm tree.  Its filename was
     dax-kmem-resolve-default-online-type-at-probe-time.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Gregory Price <gourry@gourry.net>
Subject: dax/kmem: resolve default online type at probe time
Date: Sun, 12 Jul 2026 11:45:01 -0400

Resolve the default online type in kmem at probe time explicitly instead
of implicitly inheriting the system default by calling
add_memory_driver_managed().

No behavioral change at this point (still system default).

Link: https://lore.kernel.org/20260712154505.3564379-8-gourry@gourry.net
Signed-off-by: Gregory Price <gourry@gourry.net>
Cc: Alison Schofield <alison.schofield@intel.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pankaj Gupta <pankaj.gupta@amd.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dax/kmem.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/dax/kmem.c~dax-kmem-resolve-default-online-type-at-probe-time
+++ a/drivers/dax/kmem.c
@@ -73,6 +73,7 @@ static int dev_dax_kmem_probe(struct dev
 	mhp_t mhp_flags;
 	int numa_node;
 	int adist = MEMTIER_DEFAULT_DAX_ADISTANCE;
+	int online_type = mhp_get_default_online_type();
 
 	/*
 	 * Ensure good NUMA information for the persistent memory.
@@ -172,8 +173,9 @@ static int dev_dax_kmem_probe(struct dev
 		 * Ensure that future kexec'd kernels will not treat
 		 * this as RAM automatically.
 		 */
-		rc = add_memory_driver_managed(data->mgid, range.start,
-				range_len(&range), kmem_name, mhp_flags);
+		rc = __add_memory_driver_managed(data->mgid, range.start,
+				range_len(&range), kmem_name, mhp_flags,
+				online_type);
 
 		if (rc) {
 			dev_warn(dev, "mapping%d: %#llx-%#llx memory add failed\n",
_

Patches currently in -mm which might be from gourry@gourry.net are


