Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA4AE37711;
	Thu,  8 Feb 2024 20:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707423571; cv=none; b=ZPJlSjUIbgX9Z0RHv/FnsH70XDfRLJkpGdXFKaCQSvE2HT5/yWfbcQeQaAeJ5QoE+NRbVy+SaR0ebru3hZ96dcIOPC5ZGVAb8JSzPr3O0tK4oewNFKTivNOYfA+GRpIPNGVnfuE2tw386tw0N/k+jbjqyCykOQsGJYCfigqbza8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707423571; c=relaxed/simple;
	bh=LF1TI/4K8CFSrmV7nScCwzUC576f50C6BnoIZZw8+ck=;
	h=Date:To:From:Subject:Message-Id; b=SJzQXZuufuXHSUFoqEcO/PCmyHztDxjRMhdWnx4iMUfZOrUG9kbLSqbMqeRnOUd+yhCsri6uwVaav/2me7u09wc6J08Kfy5WmWQpwqsMzMUmkFwuBeVfiW6zgtlBVQpWDEeApkQeqws+bIlL+qVpwTSnP/JMKdBGjDFi5awQIAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LpzUij05; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LpzUij05"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ED15C43390;
	Thu,  8 Feb 2024 20:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707423571;
	bh=LF1TI/4K8CFSrmV7nScCwzUC576f50C6BnoIZZw8+ck=;
	h=Date:To:From:Subject:From;
	b=LpzUij05DjAhV7pvpbeXSW2Do7A1ViJsY1tti0oKpKQjsIL48DaGcjAnHW//l/XYT
	 V9JWFa+g3p1TNGUB1lc4G9U2s8ImnIRYovaIODgETgNCUBW2GzoBX+XPfhcis6to9A
	 pIam7ROqqtSN0AJ6wQxM5K2sq08Gzrj25Y2SywJk=
Date: Thu, 08 Feb 2024 12:19:30 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,tzimmermann@suse.de,tvrtko.ursulin@linux.intel.com,stable@vger.kernel.org,rodrigo.vivi@intel.com,ray.huang@amd.com,mripard@kernel.org,maarten.lankhorst@linux.intel.com,joonas.lahtinen@linux.intel.com,jarkko@kernel.org,jani.nikula@linux.intel.com,hughd@google.com,djwong@kernel.org,dhowells@redhat.com,dave.hansen@linux.intel.com,daniel@ffwll.ch,christian.koenig@amd.com,chandan.babu@oracle.com,airlied@gmail.com,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [obsolete] xfs-disable-large-folio-support-in-xfile_create.patch removed from -mm tree
Message-Id: <20240208201931.3ED15C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: xfs: disable large folio support in xfile_create
has been removed from the -mm tree.  Its filename was
     xfs-disable-large-folio-support-in-xfile_create.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: xfs: disable large folio support in xfile_create
Date: Wed, 10 Jan 2024 10:21:09 +0100

The xfarray code will crash if large folios are force enabled using:

   echo force > /sys/kernel/mm/transparent_hugepage/shmem_enabled

Fixing this will require a bit of an API change, and prefeably sorting out
the hwpoison story for pages vs folio and where it is placed in the shmem
API.  For now use this one liner to disable large folios.

Link: https://lkml.kernel.org/r/20240110092109.1950011-3-hch@lst.de
Fixes: 3934e8ebb7cc ("xfs: create a big array data structure")
Reported-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Cc: Chandan Babu R <chandan.babu@oracle.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Dave Airlie <airlied@gmail.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Huang Rui <ray.huang@amd.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/xfs/scrub/xfile.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/xfs/scrub/xfile.c~xfs-disable-large-folio-support-in-xfile_create
+++ a/fs/xfs/scrub/xfile.c
@@ -94,6 +94,11 @@ xfile_create(
 
 	lockdep_set_class(&inode->i_rwsem, &xfile_i_mutex_key);
 
+	/*
+	 * We're not quite ready for large folios yet.
+	 */
+	mapping_clear_large_folios(inode->i_mapping);
+
 	trace_xfile_create(xf);
 
 	*xfilep = xf;
_

Patches currently in -mm which might be from hch@lst.de are


