Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A65A53B05BC
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 02:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068035; cv=none; b=f1YlJTnHrUVjvE3ys6FyPYgi0TttX6A0WIaL5JmCnfhJnGR/FY+BHxmMYtkFMdes1IKQ5JhgVSKoEHC3ldDJvz83Lf/GN8XmZKtFkhJRhvnvpUflkqQDA/OCEJo+u/kYiGsVqkX9UUhAHSp1XGLyi/EfzX6iuEAy77Zasjp8OnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068035; c=relaxed/simple;
	bh=VhS41itcrsIbVzy9ftwVQnTlRakehxrVE8DRntbVGH8=;
	h=Date:To:From:Subject:Message-Id; b=YLkrAu8f+uQ3PdMzFvj7xASs+Y53GAH1mwJhsaB72FktM1s2hapLMZ68KRrujzGAOSot/a+Ed8L6y3av1ppI3b7QpZ6Yyw83PJM1SqW3EdWpULgx7A84vS9R05ve7PeYmhj1QWF7lohPLaTBWgrtVIXFsvxgdgY0B9wVoV6KWic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HYQREaxI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HYQREaxI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BF0E1F00A3A;
	Fri,  7 Aug 2026 02:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068031;
	bh=9dAliXeGiZVyenK7h3pZ565rnfbNnIypFGJEzgerLao=;
	h=Date:To:From:Subject;
	b=HYQREaxIQnEiYkPTCVzN0Ex9YMOQy261H6o4lErYcQ2EGa/AFvgbN3GDpFlaFyfAS
	 GFnWTzrsSiSAiUrwEzZLSxpQOeKdpI9JaSmA0W2UxWmqB0VP3gnM25XGRENLQ5PBJk
	 UxfvrZVhv/HYUkmGTMWs88e9+MXTGC1qmDflYMQQ=
Date: Thu, 06 Aug 2026 19:00:30 -0700
To: mm-commits@vger.kernel.org,vishal.l.verma@intel.com,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,rafael@kernel.org,pankaj.gupta@amd.com,osalvador@suse.de,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,hare@suse.de,gregkh@linuxfoundation.org,djbw@kernel.org,david@kernel.org,dave.jiang@intel.com,dakr@kernel.org,alison.schofield@intel.com,gourry@gourry.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory_hotplug-pass-online_type-to-online_memory_block-via-arg.patch removed from -mm tree
Message-Id: <20260807020031.3BF0E1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory_hotplug: pass online_type to online_memory_block() via arg
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-pass-online_type-to-online_memory_block-via-arg.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Gregory Price <gourry@gourry.net>
Subject: mm/memory_hotplug: pass online_type to online_memory_block() via arg
Date: Sun, 12 Jul 2026 11:44:57 -0400

Modify online_memory_block() to accept the online type through its arg
parameter rather than calling mhp_get_default_online_type() internally.

This prepares for allowing callers to specify explicit online types.

Update the caller in add_memory_resource() to pass the default online
type via a local variable.

No functional change.

Link: https://lore.kernel.org/20260712154505.3564379-4-gourry@gourry.net
Signed-off-by: Gregory Price <gourry@gourry.net>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Dan Williams <djbw@kernel.org>
Cc: Alison Schofield <alison.schofield@intel.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-pass-online_type-to-online_memory_block-via-arg
+++ a/mm/memory_hotplug.c
@@ -1340,7 +1340,9 @@ static int check_hotplug_memory_range(u6
 
 static int online_memory_block(struct memory_block *mem, void *arg)
 {
-	mem->online_type = mhp_get_default_online_type();
+	enum mmop *online_type = arg;
+
+	mem->online_type = *online_type;
 	return device_online(&mem->dev);
 }
 
@@ -1497,6 +1499,7 @@ out:
 int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
 {
 	struct mhp_params params = { .pgprot = pgprot_mhp(PAGE_KERNEL) };
+	enum mmop online_type = mhp_get_default_online_type();
 	enum memblock_flags memblock_flags = MEMBLOCK_NONE;
 	struct memory_group *group = NULL;
 	u64 start, size;
@@ -1585,7 +1588,8 @@ int add_memory_resource(int nid, struct
 
 	/* online pages if requested */
 	if (mhp_get_default_online_type() != MMOP_OFFLINE)
-		walk_memory_blocks(start, size, NULL, online_memory_block);
+		walk_memory_blocks(start, size, &online_type,
+				   online_memory_block);
 
 	return ret;
 error:
_

Patches currently in -mm which might be from gourry@gourry.net are


