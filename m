Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A961A55
	for <mm-commits@vger.kernel.org>; Sat,  6 Sep 2025 01:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757122251; cv=none; b=bnsarxHXa9SuYXb/gQe4EVhdxOHFi523WGqG2SQhT1SXIqzrtCm6vy2zsMYqJi18f9tByAwcExSRz+ik+Dc97P99NLHEd2sySXqDzw0SfwfJEJoG1rkAxzqS0fC4QZRbLDLGWdZoV3/oBurQDee/3BY2VzD7BBdZW7vNqa6MTbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757122251; c=relaxed/simple;
	bh=Xmj9WtbWfCLfrfU6q2iEOaHz8nhRigDwFwQrgSWMzkQ=;
	h=Date:To:From:Subject:Message-Id; b=f3c+bGpVqQKsppLvqppiVXZRtllttdITGhIqsRelyZNvNV0JlPp1xpmuNmJzCaV+Fw6FNAlwzKFTEwk51VIN4TSzkLsXRweqAuDJ3ZIQb8Vjhfcr86+pxnXeoL3EKfsXYcPyWlVzXQ8RT6QyKUjSW9pQaOMK23p3qX/IvKa/+OM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BuVjLPPJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BuVjLPPJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98A7FC4CEF1;
	Sat,  6 Sep 2025 01:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757122250;
	bh=Xmj9WtbWfCLfrfU6q2iEOaHz8nhRigDwFwQrgSWMzkQ=;
	h=Date:To:From:Subject:From;
	b=BuVjLPPJzDHi1zDo4JOgvnBdVmGoC1/x+WBa75NvN1AT1NwewJWx9ZTugZ3BUpmue
	 ZiBjiJje/W521Jb913hl0hroTHH2lUSva7cHnZte8NIjdpCIrvOVO7l/x1+VndmNVu
	 o38OcXxZMyOEsJf0oSUcYeIwOYkx4ZesgQSswVeA=
Date: Fri, 05 Sep 2025 18:30:49 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,disclosure@aisle.com,stanislav.fort@aisle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-v1-account-event-registrations-and-drop-world-writable-cgroupevent_control.patch added to mm-new branch
Message-Id: <20250906013050.98A7FC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memcg: v1: account event registrations and drop world-writable cgroup.event_control
has been added to the -mm mm-new branch.  Its filename is
     mm-memcg-v1-account-event-registrations-and-drop-world-writable-cgroupevent_control.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-v1-account-event-registrations-and-drop-world-writable-cgroupevent_control.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

mm-damon-sysfs-fix-use-after-free-in-state_show.patch
mm-memcg-v1-account-event-registrations-and-drop-world-writable-cgroupevent_control.patch

