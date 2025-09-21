Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 847ED21D3C0
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489955; cv=none; b=VnvlRviqy887YWGgJs89r/BEii0Rv7/u6SLBSblnMLIcM1IwiNpPyTRKrMnKqTVy+3zd6/tsD45LYEHiTs6D+V9oLcUe/ymaRCBsO0rVUrQC6RuEaZm4Iip5y8keVtyaCeHp/GzQug/BxCLN+bNQpU5HZ+Zlj3DuzFP9JKc9uk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489955; c=relaxed/simple;
	bh=bz+jCskazt9IVIUJmNQdmgvK1MMFm9dElrD2p7CKaRA=;
	h=Date:To:From:Subject:Message-Id; b=jk+6eurVJTi2NdEH6MQSL4QEjDbOg9Phvhan6OMnGjfqlxCe/zahlesoXKYnBxtZy0YDDBXCyXYw0nWO4k77/Gns/GWgsXiaCx5DMeUpz1mmSLcAONlnGvBFFmQjUSZVuu1QIchOhXfx5VeeDw8M5voXNShc33W/qTjNpnKT+RE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nZZjvwTs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nZZjvwTs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52A63C4CEE7;
	Sun, 21 Sep 2025 21:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489955;
	bh=bz+jCskazt9IVIUJmNQdmgvK1MMFm9dElrD2p7CKaRA=;
	h=Date:To:From:Subject:From;
	b=nZZjvwTsz5/sgXbpu/RtaikoEFsbCMLeLkSrawQv5wMD9eMmPNuqeMoA0AI9vTRFy
	 eDebjgXm9FBaU9M0BSLFMwVprNFquMXYBKkcGX5yL43X/fx7lc+X3SLDp+uXHTeMgj
	 7310ckjPpNI/K79kOR3XfdAP26rKnt318Kzm7vTg=
Date: Sun, 21 Sep 2025 14:25:54 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,disclosure@aisle.com,stanislav.fort@aisle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcg-v1-account-event-registrations-and-drop-world-writable-cgroupevent_control.patch removed from -mm tree
Message-Id: <20250921212555.52A63C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memcg: v1: account event registrations and drop world-writable cgroup.event_control
has been removed from the -mm tree.  Its filename was
     mm-memcg-v1-account-event-registrations-and-drop-world-writable-cgroupevent_control.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Stanislav Fort <stanislav.fort@aisle.com>
Subject: mm/memcg: v1: account event registrations and drop world-writable cgroup.event_control
Date: Fri, 5 Sep 2025 12:38:51 +0300

In cgroup v1, the legacy cgroup.event_control file is world-writable and
allows unprivileged users to register unbounded events and thresholds. 
Each registration allocates kernel memory without capping or memcg
charging, which can be abused to exhaust kernel memory in affected
configurations.

Make the following minimal changes:
- Account allocations with __GFP_ACCOUNT in event and threshold registration.
- Remove CFTYPE_WORLD_WRITABLE from cgroup.event_control to make it
  owner-writable.

This does not affect cgroup v2.  Allocations are still subject to kmem
accounting being enabled, but this reduces unbounded global growth.

Link: https://lkml.kernel.org/r/20250905093851.80596-1-disclosure@aisle.com
Signed-off-by: Stanislav Fort <disclosure@aisle.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol-v1.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/memcontrol-v1.c~mm-memcg-v1-account-event-registrations-and-drop-world-writable-cgroupevent_control
+++ a/mm/memcontrol-v1.c
@@ -761,7 +761,7 @@ static int __mem_cgroup_usage_register_e
 	size = thresholds->primary ? thresholds->primary->size + 1 : 1;
 
 	/* Allocate memory for new array of thresholds */
-	new = kmalloc(struct_size(new, entries, size), GFP_KERNEL);
+	new = kmalloc(struct_size(new, entries, size), GFP_KERNEL_ACCOUNT);
 	if (!new) {
 		ret = -ENOMEM;
 		goto unlock;
@@ -924,7 +924,7 @@ static int mem_cgroup_oom_register_event
 {
 	struct mem_cgroup_eventfd_list *event;
 
-	event = kmalloc(sizeof(*event),	GFP_KERNEL);
+	event = kmalloc(sizeof(*event),	GFP_KERNEL_ACCOUNT);
 	if (!event)
 		return -ENOMEM;
 
@@ -1087,7 +1087,7 @@ static ssize_t memcg_write_event_control
 
 	CLASS(fd, cfile)(cfd);
 
-	event = kzalloc(sizeof(*event), GFP_KERNEL);
+	event = kzalloc(sizeof(*event), GFP_KERNEL_ACCOUNT);
 	if (!event)
 		return -ENOMEM;
 
@@ -2053,7 +2053,7 @@ struct cftype mem_cgroup_legacy_files[]
 	{
 		.name = "cgroup.event_control",		/* XXX: for compat */
 		.write = memcg_write_event_control,
-		.flags = CFTYPE_NO_PREFIX | CFTYPE_WORLD_WRITABLE,
+		.flags = CFTYPE_NO_PREFIX,
 	},
 	{
 		.name = "swappiness",
_

Patches currently in -mm which might be from stanislav.fort@aisle.com are


