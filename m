Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3379218EA1
	for <mm-commits@vger.kernel.org>; Wed,  6 Mar 2024 21:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709759293; cv=none; b=IIuEi8ktI4aSQYMqcV8+FWmZnKpOsfipJilHBJSsBU75Ry/beSIhfaqD4EgPp0ME/qehepuzK7KIe8MPosdCB0V9GOoQnD5qNcWZQQv5YOVYEvAkHQccoTEYD/jH1BqpJowf6zjYKFlR0AqX/GlUZoWE/rPVRzITQfEkyo6T05I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709759293; c=relaxed/simple;
	bh=VauEUSTNEYjChCaxE5Z1Zwi0rSCrTrsxfhwr6UZxnXw=;
	h=Date:To:From:Subject:Message-Id; b=Q0MEu6J6TCDi0vTx5Eoe6bNYSzSE646W+UfwfqlwYad1s70nyZm0KMwcJixEUCzWT0owjYwcCkwfOwLwjMEOVs/fezkft3G4E/rlbeWeYzFWD4r+hiD5+Cs/IhqtQzzgog3sXGXLsw6SPK0WhTycwaW4R0XtsqvcBzI1PkGrIy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xHjvzJEv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xHjvzJEv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94A6DC433C7;
	Wed,  6 Mar 2024 21:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709759292;
	bh=VauEUSTNEYjChCaxE5Z1Zwi0rSCrTrsxfhwr6UZxnXw=;
	h=Date:To:From:Subject:From;
	b=xHjvzJEvGGww0zwHvFMBukFvSc4Kj8WO4NJj/6WpCiA3IlFEQzIrLjSClF7TMKOCz
	 bXdA32n82+dFo0He5r0OYmMVUgrkD+dLNvUtgl22MEPqZj9KG14nx2r9xWijQ/cNR+
	 kUIw+4lW51k1/4RzG3G1L5v7ukt9QB1/6qRYodjU=
Date: Wed, 06 Mar 2024 13:08:12 -0800
To: mm-commits@vger.kernel.org,joe@perches.com,gregkh@linuxfoundation.org,ricardo@marliere.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] const_structscheckpatch-add-device_type.patch removed from -mm tree
Message-Id: <20240306210812.94A6DC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: const_structs.checkpatch: add device_type
has been removed from the -mm tree.  Its filename was
     const_structscheckpatch-add-device_type.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Ricardo B. Marliere" <ricardo@marliere.net>
Subject: const_structs.checkpatch: add device_type
Date: Sun, 18 Feb 2024 16:25:51 -0300

Since commit aed65af1cc2f ("drivers: make device_type const"), the driver
core can properly handle constant struct device_type.  Make sure that new
usages of the struct already enter the tree as const.

Link: https://lkml.kernel.org/r/20240218-device_cleanup-checkpatch-v1-1-8b0b89c4f6b1@marliere.net
Signed-off-by: Ricardo B. Marliere <ricardo@marliere.net>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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


