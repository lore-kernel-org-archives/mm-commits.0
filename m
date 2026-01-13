Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFA462DBF78
	for <mm-commits@vger.kernel.org>; Tue, 13 Jan 2026 05:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768280961; cv=none; b=M6CvAUT5Mvtqc5peGKZTrYPKtAb1/WslHKMRIGcQ6jg+GaHGvnYYXfRO4Z2gMiVIQ6Uq6a68f5EO7YI8Qyx3fvvUMM3lHAXQBA8yT3xsCN935lvaRWVrH+UdbXieUivagS6s1nI54E1peZZGDZbXwqBKGQAO86rlIk77bUamiSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768280961; c=relaxed/simple;
	bh=mM47522xKOylwXhK5T4CDAt+pYzZgorLX2+vMx23j2Y=;
	h=Date:To:From:Subject:Message-Id; b=UNf3jTsVf9FcabcoyYXGVj1vDj1ml2P+kFqCGE1uOiG8zfXR7vT2gQHO61pd7JqR27a+coDW7FRNCHCDd5yu7Qw7+4qxADXRWlQVhwVz+SieOIPnnVid/UAVe+eKwK0SXFZkKEbtYkR59/7wisWC/Pw1egIElQX1t0popf0sGEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=t+6w2Irg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="t+6w2Irg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A384C116C6;
	Tue, 13 Jan 2026 05:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768280961;
	bh=mM47522xKOylwXhK5T4CDAt+pYzZgorLX2+vMx23j2Y=;
	h=Date:To:From:Subject:From;
	b=t+6w2IrgLt10mfFK3cL7WccWSOQxjSDf+pTsz5yPQAdt1k+6FUZFWBnN38cmVevxc
	 j/ks7EkGV6bsEeoFRKYY7nAgtsrkurtUzC6H3/dr3UvwBBVc2MIhLigEjsByFv7ksw
	 7MxTHQigqbAmPkKu5MMhnzVD4KTQjDzujKNuMpZI=
Date: Mon, 12 Jan 2026 21:09:20 -0800
To: mm-commits@vger.kernel.org,harry.yoo@oracle.com,elver@google.com,david@kernel.org,bagasdotme@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-kfence-describe-slab-parameter-in-__kfence_obj_info.patch removed from -mm tree
Message-Id: <20260113050921.7A384C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm, kfence: describe @slab parameter in __kfence_obj_info()
has been removed from the -mm tree.  Its filename was
     mm-kfence-describe-slab-parameter-in-__kfence_obj_info.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Bagas Sanjaya <bagasdotme@gmail.com>
Subject: mm, kfence: describe @slab parameter in __kfence_obj_info()
Date: Fri, 19 Dec 2025 08:40:07 +0700

Sphinx reports kernel-doc warning:

WARNING: ./include/linux/kfence.h:220 function parameter 'slab' not described in '__kfence_obj_info'

Fix it by describing @slab parameter.

Link: https://lkml.kernel.org/r/20251219014006.16328-6-bagasdotme@gmail.com
Fixes: 2dfe63e61cc3 ("mm, kfence: support kmem_dump_obj() for KFENCE objects")
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
Acked-by: Marco Elver <elver@google.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Acked-by: Harry Yoo <harry.yoo@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kfence.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/kfence.h~mm-kfence-describe-slab-parameter-in-__kfence_obj_info
+++ a/include/linux/kfence.h
@@ -211,6 +211,7 @@ struct kmem_obj_info;
  * __kfence_obj_info() - fill kmem_obj_info struct
  * @kpp: kmem_obj_info to be filled
  * @object: the object
+ * @slab: the slab
  *
  * Return:
  * * false - not a KFENCE object
_

Patches currently in -mm which might be from bagasdotme@gmail.com are


