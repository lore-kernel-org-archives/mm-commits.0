Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E88F2E2F14
	for <mm-commits@vger.kernel.org>; Thu, 12 Feb 2026 23:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770939839; cv=none; b=WxaTO4WMnywHRg3bpLl00tBWSocjgmBX/knZcucGdLpNQfjMFf0sdEjI2SS89Aa5PgyA0j3okgPg51VGyDWYufZ+tWQ1+CEtOfHWniapu1KtUbV7GbqdxqGn61XC1cjAWBNz17RshlXeJvR1XLIeewlHNz9RtitcjM/x6uUnOSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770939839; c=relaxed/simple;
	bh=3J7G8I+GroKVKpO0Ey3pEGzbe706Ij9VjX4KiaIVUDc=;
	h=Date:To:From:Subject:Message-Id; b=pqLhnWAOa68FEcOYL3VYB89MQgNhSnDHqgLsGJdGXtGz9tSyMXgJpyg0s17BJIHcAX3Lp7vt7JI5uEbngTIBqAkuyXARVMltQ6MWvbV1orpe/eaQ08cwNHNtxxcsv4EjXarf87z+Ge6MlaQUjNJPgZaLXMfwf2SQyJ6KoVV8mgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zKMslcjd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zKMslcjd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 679CDC4CEF7;
	Thu, 12 Feb 2026 23:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770939839;
	bh=3J7G8I+GroKVKpO0Ey3pEGzbe706Ij9VjX4KiaIVUDc=;
	h=Date:To:From:Subject:From;
	b=zKMslcjd4xyjeiY39s/G599CRHOCYp3ED8+BtekeOFCHXonDk7gXkmRTKYRB7ksbh
	 SVFhBU+TnC4CaRyOgSRC12RkwuNupH9OgtVcYtrW+rTbf30wO7kWZD5BdEAPvK7hZ+
	 Sknli0mMcr7ecxPa1i0AOG0cCPdYie3B8p0W1OUc=
Date: Thu, 12 Feb 2026 15:43:58 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ynorov@nvidia.com,vbabka@suse.cz,surenb@google.com,pfalcato@suse.de,Liam.Howlett@oracle.com,jgg@nvidia.com,jarkko@kernel.org,dlemoal@kernel.org,djwong@kernel.org,dev.jain@arm.com,david@kernel.org,clm@fb.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-mk_vma_flags-bitmap-flag-macro-helper.patch removed from -mm tree
Message-Id: <20260212234359.679CDC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: add mk_vma_flags() bitmap flag macro helper
has been removed from the -mm tree.  Its filename was
     mm-add-mk_vma_flags-bitmap-flag-macro-helper.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm: add mk_vma_flags() bitmap flag macro helper
Date: Thu, 22 Jan 2026 16:06:12 +0000

This patch introduces the mk_vma_flags() macro helper to allow easy
manipulation of VMA flags utilising the new bitmap representation
implemented of VMA flags defined by the vma_flags_t type.

It is a variadic macro which provides a bitwise-or'd representation of all
of each individual VMA flag specified.

Note that, while we maintain VM_xxx flags for backwards compatibility
until the conversion is complete, we define VMA flags of type vma_flag_t
using VMA_xxx_BIT to avoid confusing the two.

This helper macro therefore can be used thusly:

vma_flags_t flags = mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT);

Testing has demonstrated that the compiler optimises this code such that
it generates the same assembly utilising this macro as it does if the
flags were specified manually, for instance:

vma_flags_t get_flags(void)
{
	return mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT, VMA_EXEC_BIT);
}

Generates the same code as:

vma_flags_t get_flags(void)
{
	vma_flags_t flags;

	vma_flags_clear_all(&flags);
	vma_flag_set(&flags, VMA_READ_BIT);
	vma_flag_set(&flags, VMA_WRITE_BIT);
	vma_flag_set(&flags, VMA_EXEC_BIT);

	return flags;
}

And:

vma_flags_t get_flags(void)
{
	vma_flags_t flags;
	unsigned long *bitmap = ACCESS_PRIVATE(&flags, __vma_flags);

	*bitmap = 1UL << (__force int)VMA_READ_BIT;
	*bitmap |= 1UL << (__force int)VMA_WRITE_BIT;
	*bitmap |= 1UL << (__force int)VMA_EXEC_BIT;

	return flags;
}

That is:

get_flags:
        movl    $7, %eax
        ret

Link: https://lkml.kernel.org/r/fde00df6ff7fb8c4b42cc0defa5a4924c7a1943a.1769097829.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Yury Norov <ynorov@nvidia.com>
Cc: Chris Mason <clm@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

--- a/include/linux/mm.h~mm-add-mk_vma_flags-bitmap-flag-macro-helper
+++ a/include/linux/mm.h
@@ -2,6 +2,7 @@
 #ifndef _LINUX_MM_H
 #define _LINUX_MM_H
 
+#include <linux/args.h>
 #include <linux/errno.h>
 #include <linux/mmdebug.h>
 #include <linux/gfp.h>
@@ -1026,6 +1027,38 @@ static inline bool vma_test_atomic_flag(
 	return false;
 }
 
+/* Set an individual VMA flag in flags, non-atomically. */
+static inline void vma_flag_set(vma_flags_t *flags, vma_flag_t bit)
+{
+	unsigned long *bitmap = flags->__vma_flags;
+
+	__set_bit((__force int)bit, bitmap);
+}
+
+static inline vma_flags_t __mk_vma_flags(size_t count, const vma_flag_t *bits)
+{
+	vma_flags_t flags;
+	int i;
+
+	vma_flags_clear_all(&flags);
+	for (i = 0; i < count; i++)
+		vma_flag_set(&flags, bits[i]);
+	return flags;
+}
+
+/*
+ * Helper macro which bitwise-or combines the specified input flags into a
+ * vma_flags_t bitmap value. E.g.:
+ *
+ * vma_flags_t flags = mk_vma_flags(VMA_IO_BIT, VMA_PFNMAP_BIT,
+ * 		VMA_DONTEXPAND_BIT, VMA_DONTDUMP_BIT);
+ *
+ * The compiler cleverly optimises away all of the work and this ends up being
+ * equivalent to aggregating the values manually.
+ */
+#define mk_vma_flags(...) __mk_vma_flags(COUNT_ARGS(__VA_ARGS__), \
+					 (const vma_flag_t []){__VA_ARGS__})
+
 static inline void vma_set_anonymous(struct vm_area_struct *vma)
 {
 	vma->vm_ops = NULL;
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are


