Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35B61495F0
	for <mm-commits@vger.kernel.org>; Mon,  5 Feb 2024 23:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707175803; cv=none; b=mw9e3VzjuBVh6C0qk1C33jBtuPioIXeMaPNXxPYHdzgiv1ldK5VyFOKPLgoxUubGwAqUQXdpaUj2/xWq039MDzI2aTWMs0VV60lt8lII2aHZkWgCko7eOaPJCq32wh7i1fn9iiFtAT5UdDz7iIEphbDhIVTVsdPyGjm21xKskxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707175803; c=relaxed/simple;
	bh=g7/0suQBmu4dv/AE/WYYIvSgLDV+PAey8sL8GluQm8M=;
	h=Date:To:From:Subject:Message-Id; b=PyplcEBxxNMl0n2pNUY9LxBBuX6FZpxHfj9pzoDwJf01iNQ/bBFUWT7+JiXlxYTGgVXireI9nbeZAMuVqChvcST4FxVrnZ/jMJt4Lb0aqj81F/eDB0NVoZNY8udQPhrjwkpn5eKoRo5CZx/0ZY04iDIhs1pzasAkF9CXYIL7MhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lJ6MFu5r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lJ6MFu5r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97459C433C7;
	Mon,  5 Feb 2024 23:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707175802;
	bh=g7/0suQBmu4dv/AE/WYYIvSgLDV+PAey8sL8GluQm8M=;
	h=Date:To:From:Subject:From;
	b=lJ6MFu5rAZCPTY0FZtQsAodyBFucDiCGNDyBgIsnIOYkIa8kDXH4XhJzp7Vo5qFSB
	 I6CTlzQxUVJG123/7hrnJwn3vgrAWyErnBKCZdXsBd84FvSFFJ/yOCK3Sb4EjL2bOy
	 vITVUs0wVNA1gAfETPYlYPCmo+ZCWPHtKRGtK9OI=
Date: Mon, 05 Feb 2024 15:30:02 -0800
To: mm-commits@vger.kernel.org,gregkh@linuxfoundation.org,ricardo@marliere.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memory-tier-make-memory_tier_subsys-const.patch added to mm-unstable branch
Message-Id: <20240205233002.97459C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memory tier: make memory_tier_subsys const
has been added to the -mm mm-unstable branch.  Its filename is
     memory-tier-make-memory_tier_subsys-const.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memory-tier-make-memory_tier_subsys-const.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: "Ricardo B. Marliere" <ricardo@marliere.net>
Subject: memory tier: make memory_tier_subsys const
Date: Sun, 04 Feb 2024 10:56:44 -0300

Now that the driver core can properly handle constant struct bus_type,
move the memory_tier_subsys variable to be a constant structure as well,
placing it into read-only memory which can not be modified at runtime.

Link: https://lkml.kernel.org/r/20240204-bus_cleanup-mm-v1-1-00f49286f164@marliere.net
Signed-off-by: Ricardo B. Marliere <ricardo@marliere.net>
Suggested-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-tiers.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory-tiers.c~memory-tier-make-memory_tier_subsys-const
+++ a/mm/memory-tiers.c
@@ -39,7 +39,7 @@ static LIST_HEAD(memory_tiers);
 static struct node_memory_type_map node_memory_types[MAX_NUMNODES];
 struct memory_dev_type *default_dram_type;
 
-static struct bus_type memory_tier_subsys = {
+static const struct bus_type memory_tier_subsys = {
 	.name = "memory_tiering",
 	.dev_name = "memory_tier",
 };
_

Patches currently in -mm which might be from ricardo@marliere.net are

memory-tier-make-memory_tier_subsys-const.patch
const_structscheckpatch-add-bus_type.patch

