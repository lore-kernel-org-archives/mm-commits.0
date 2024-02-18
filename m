Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF46A8C1A
	for <mm-commits@vger.kernel.org>; Sun, 18 Feb 2024 21:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708291664; cv=none; b=obXlNW7718Qeg1tSNWfw7idIqQD3B2oCVxYKPllSEUKjWK1GZfvgCa5R0va4axcikMZkI/80O0WvVVuvaBiRxjbFWK79Q1xVxvyFa8n5i4+IQ3iT4ga47UhdgDr87lMfZkW0xxuDz9wBIbiPUP0SS8e7qzYJlUnlRK8o9SUGMT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708291664; c=relaxed/simple;
	bh=Gq5NMZq/kf7OGmLPzR+DvjoNOzOZlW3aetl19shuL4Y=;
	h=Date:To:From:Subject:Message-Id; b=VRtl6+KfsBxCNn8tBUWKIzv0mBhASanfdde1iH6+WMl1FhQ+o9CcvFA0ALSq/KXSSH6bvw1Jn9e+l/X98Pgro4O49xKuVoCUHTxDSqA8/hIANoiQfNVnNFXTG9r6iHjRyOlwFZB/K495j6KD8T+iY5B+ThnW9XTP+O1z1i2x5ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xphdffWI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xphdffWI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A027C433C7;
	Sun, 18 Feb 2024 21:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708291664;
	bh=Gq5NMZq/kf7OGmLPzR+DvjoNOzOZlW3aetl19shuL4Y=;
	h=Date:To:From:Subject:From;
	b=xphdffWI5GBwbk2ZwwjVDUQzBkUTiig/hhbR5l4oyfAR0OYBQVN/4pWOspKrKwj+m
	 0nMdGss8uHzKsE6v1d9Vxs9JQnbMOyVCM6/A6qTwTVoMqs6R2lRz+c6C7D5+kbZa0r
	 FnQDMKY/2bVXXfjNz9SS1KrAlkZLirHmm7WI0d5w=
Date: Sun, 18 Feb 2024 13:27:43 -0800
To: mm-commits@vger.kernel.org,joe@perches.com,gregkh@linuxfoundation.org,ricardo@marliere.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + const_structscheckpatch-add-device_type.patch added to mm-nonmm-unstable branch
Message-Id: <20240218212744.3A027C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: const_structs.checkpatch: add device_type
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     const_structscheckpatch-add-device_type.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/const_structscheckpatch-add-device_type.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
Subject: const_structs.checkpatch: add device_type
Date: Sun, 18 Feb 2024 16:25:51 -0300

Since commit aed65af1cc2f ("drivers: make device_type const"), the driver
core can properly handle constant struct device_type.  Make sure that new
usages of the struct already enter the tree as const.

Link: https://lkml.kernel.org/r/20240218-device_cleanup-checkpatch-v1-1-8b0b89c4f6b1@marliere.net
Signed-off-by: Ricardo B. Marliere <ricardo@marliere.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/const_structs.checkpatch |    1 +
 1 file changed, 1 insertion(+)

--- a/scripts/const_structs.checkpatch~const_structscheckpatch-add-device_type
+++ a/scripts/const_structs.checkpatch
@@ -8,6 +8,7 @@ comedi_lrange
 component_ops
 dentry_operations
 dev_pm_ops
+device_type
 dma_map_ops
 driver_info
 drm_connector_funcs
_

Patches currently in -mm which might be from ricardo@marliere.net are

memory-tier-make-memory_tier_subsys-const.patch
const_structscheckpatch-add-bus_type.patch
const_structscheckpatch-add-device_type.patch

