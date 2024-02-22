Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55CA02919
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560193; cv=none; b=Mjv77wbyOSJX2ENNtpW3TRA8Dazga2pXDYS8m2gHJuJkyVQb/Cr6raN2KcDwOSY02H/bijgCge8IjHMYH2oT1/PfsqqZdNP89FV+Zbcn4mseWxvcLtNLBCcsBupsb4MwNeUZZmTbWVdDhecX44XGfEvSD+3JI9qsvN5ufJ5NWLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560193; c=relaxed/simple;
	bh=cPCsZ1keCEUKghavxcJnCyodHsvLDbnDI2iq+5GcaD8=;
	h=Date:To:From:Subject:Message-Id; b=S1jHVX2qX9wbZL/OM4/RMFGvDMl70Hrhrs3Jx/t2Rh9UaIk4TplvuAGTXTLlC1k1avc2xtFwCm3djYD1aguuQjz/IfL6czZthWxCLAQvFRMGz6mIDUWjsPbjymC3936MYum1b9yhvCukgy39XkjR/25obtCY+n9E7CwknFQ1DU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Nap0FDqM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Nap0FDqM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C484C43394;
	Thu, 22 Feb 2024 00:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560193;
	bh=cPCsZ1keCEUKghavxcJnCyodHsvLDbnDI2iq+5GcaD8=;
	h=Date:To:From:Subject:From;
	b=Nap0FDqMfEeP2KE5kqcNmDiDrJrgXG+3oywlCGPUd/XCp4a49JTPS9u+tS32qf+RE
	 jI030I3al6LopmBOqgvd39bGa5y0+tV0u5qkPOtO/5PhMSBMLdn13W+DxT7aGjNKow
	 E7ancWgtFpbdS16yoAFwlOaDQq1v8jqDL0TOJZNg=
Date: Wed, 21 Feb 2024 16:03:12 -0800
To: mm-commits@vger.kernel.org,gregkh@linuxfoundation.org,ricardo@marliere.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memory-tier-make-memory_tier_subsys-const.patch removed from -mm tree
Message-Id: <20240222000313.2C484C43394@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memory tier: make memory_tier_subsys const
has been removed from the -mm tree.  Its filename was
     memory-tier-make-memory_tier_subsys-const.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

const_structscheckpatch-add-bus_type.patch
const_structscheckpatch-add-device_type.patch

