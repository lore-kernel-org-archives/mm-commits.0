Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2B103AFD12
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 02:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068034; cv=none; b=ectX4D8N1M0aqIjpm5ZVTuD7lfI7xeQd87woSt1ejJM8xowosjbi9aXJMTshLTaf+9YHEe7QrcUVgRSrYTp7EwY7A5NT9w8GUjMCsnz/8XZnEtGL0dJgvTSiB9hGFm6hem0JJj7nmB9CchhvGaSB4aU8PbV8HmK/NxM490yQfIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068034; c=relaxed/simple;
	bh=mvBLV4Vl7RQNwY2wcjZp/pdODH5k5uF6FFyaqnOVag8=;
	h=Date:To:From:Subject:Message-Id; b=rVKoj3Ji5vjMQb6D+Q309Oem/eXK0eDvUM4VbXMqks6gUfWHRKP7DKR5WmKD8wgH6gO7h2pJps0m943EnkKSTqFJAMF827KwCW+vJCwLkCQeJNk8eK3uOGV5MRrlx/Vv6Bax2hoUwvHZm1t6DpmHaICWlYmg5f6BKs/BRnCc2JE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BQLCv/pf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BQLCv/pf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E70111F00AC4;
	Fri,  7 Aug 2026 02:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068030;
	bh=9NET/QDYB/KvgxO8B+cwUHQ5OtTmvQT4g9FHCjuqqsM=;
	h=Date:To:From:Subject;
	b=BQLCv/pfvh2Pe1vi4c8xSXCMdRCZled0CPlEsuvKSfCzxEYgh76Sl+d+BQZOHpyjB
	 8WYoaYbpWWTukrSEH00U+E4wwTrGBcQCyaD9CMon6iWXGJZltUcOi0Gkf4tuRJuyw1
	 RlGyNiLDrIenm5QSWlbFic0wOY7+KlLxrTwrhD7s=
Date: Thu, 06 Aug 2026 19:00:29 -0700
To: mm-commits@vger.kernel.org,vishal.l.verma@intel.com,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,rafael@kernel.org,pankaj.gupta@amd.com,osalvador@suse.de,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,hare@suse.de,gregkh@linuxfoundation.org,djbw@kernel.org,david@kernel.org,dave.jiang@intel.com,dakr@kernel.org,alison.schofield@intel.com,gourry@gourry.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory_hotplug-add-mhp_online_type_to_str-and-export-string-helpers.patch removed from -mm tree
Message-Id: <20260807020029.E70111F00AC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory_hotplug: add mhp_online_type_to_str() and export string helpers
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-add-mhp_online_type_to_str-and-export-string-helpers.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Gregory Price <gourry@gourry.net>
Subject: mm/memory_hotplug: add mhp_online_type_to_str() and export string helpers
Date: Sun, 12 Jul 2026 11:44:56 -0400

Add mhp_online_type_to_str() as the inverse of mhp_online_type_from_str(),
and export both so a driver can render and parse the memory online type
through its own sysfs interface.

Link: https://lore.kernel.org/20260712154505.3564379-3-gourry@gourry.net
Signed-off-by: Gregory Price <gourry@gourry.net>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
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
Cc: Pankaj Gupta <pankaj.gupta@amd.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c          |    9 +++++++++
 include/linux/memory_hotplug.h |    1 +
 2 files changed, 10 insertions(+)

--- a/drivers/base/memory.c~mm-memory_hotplug-add-mhp_online_type_to_str-and-export-string-helpers
+++ a/drivers/base/memory.c
@@ -46,6 +46,15 @@ int mhp_online_type_from_str(const char
 	}
 	return -EINVAL;
 }
+EXPORT_SYMBOL_GPL(mhp_online_type_from_str);
+
+const char *mhp_online_type_to_str(int online_type)
+{
+	if (online_type < 0 || online_type >= (int)ARRAY_SIZE(online_type_to_str))
+		return NULL;
+	return online_type_to_str[online_type];
+}
+EXPORT_SYMBOL_GPL(mhp_online_type_to_str);
 
 #define to_memory_block(dev) container_of(dev, struct memory_block, dev)
 
--- a/include/linux/memory_hotplug.h~mm-memory_hotplug-add-mhp_online_type_to_str-and-export-string-helpers
+++ a/include/linux/memory_hotplug.h
@@ -127,6 +127,7 @@ extern int arch_add_memory(int nid, u64
 extern u64 max_mem_size;
 
 extern int mhp_online_type_from_str(const char *str);
+const char *mhp_online_type_to_str(int online_type);
 
 /* If movable_node boot option specified */
 extern bool movable_node_enabled;
_

Patches currently in -mm which might be from gourry@gourry.net are


