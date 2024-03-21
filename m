Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E423133402
	for <mm-commits@vger.kernel.org>; Thu, 21 Mar 2024 21:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711057092; cv=none; b=f6H06dZ8UhHVAUCMaxwe1KTEYm5RczMH6rpVXML8Ak7Wpt+TLK8M84DZyHlTqAtd0+AlenGO8mwUJDc4vaz15DmAvXOFrBl6yygGP/kOn8aaqDp0PEXWlNLvgPXylZQHAo0yKWCD9Z5HKEKbixQ0zrfBvsQY7l7MGEgVRaLV7nA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711057092; c=relaxed/simple;
	bh=oukHOt4OvwYtTNzrFoXemgGTSegszahQ5170hiLfMLk=;
	h=Date:To:From:Subject:Message-Id; b=Gsm1smn4QNr//VkHpcK1fEC0Pt+UrWz+kZQXF4jOjq7IpNYvFlJgmLAuRo9wc9yk6M7ci/2UgNSgO74/vIkOPfdydGLyRM7ojrF7Ry6+gXBwR/ELiz0PctKF4rD83HrnqBa6UJk7f+zqlDL5eHoVb+WLvYYCbOAZwq3PVBD1+pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BiuNcZKS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BiuNcZKS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01AD5C433C7;
	Thu, 21 Mar 2024 21:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711057092;
	bh=oukHOt4OvwYtTNzrFoXemgGTSegszahQ5170hiLfMLk=;
	h=Date:To:From:Subject:From;
	b=BiuNcZKSHCI/tYCrmHbDSXddX4XKwj4v7+XH6lTrGqq9PNzHl9bNT+p0PycRiYtM+
	 28TspyK/BhYYo6ZZh+1bLMlEhEfv8OSm/KQ784Z6rd0sYFyW/KBhDu7mwpc8YrsvHr
	 e8wlnkc8kj6DYnsKzgFKPbN7X5xm2/TrTLI13hwk=
Date: Thu, 21 Mar 2024 14:38:11 -0700
To: mm-commits@vger.kernel.org,aneesh.kumar@kernel.org,donettom@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mempolicy-use-numa_node_id-instead-of-cpu_to_node-v3.patch added to mm-unstable branch
Message-Id: <20240321213812.01AD5C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-mempolicy-use-numa_node_id-instead-of-cpu_to_node-v3
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mempolicy-use-numa_node_id-instead-of-cpu_to_node-v3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mempolicy-use-numa_node_id-instead-of-cpu_to_node-v3.patch

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
From: Donet Tom <donettom@linux.ibm.com>
Subject: mm-mempolicy-use-numa_node_id-instead-of-cpu_to_node-v3
Date: Thu, 21 Mar 2024 06:29:50 -0500

add "* @vmf: structure describing the fault" comment for mpol_misplaced()
to fix the warning.  

Link: https://lkml.kernel.org/r/d8b993ea9dccfac0bc3ed61d3a81f4ac5f376e46.1711002865.git.donettom@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V (IBM) <aneesh.kumar@kernel.org>
Signed-off-by: Donet Tom <donettom@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mempolicy.c~mm-mempolicy-use-numa_node_id-instead-of-cpu_to_node-v3
+++ a/mm/mempolicy.c
@@ -2718,7 +2718,7 @@ static void sp_free(struct sp_node *n)
  * mpol_misplaced - check whether current folio node is valid in policy
  *
  * @folio: folio to be checked
- * @vma: vm area where folio mapped
+ * @vmf: structure describing the fault
  * @addr: virtual address in @vma for shared policy lookup and interleave policy
  *
  * Lookup current policy node id for vma,addr and "compare to" folio's
_

Patches currently in -mm which might be from donettom@linux.ibm.com are

mm-mempolicy-use-numa_node_id-instead-of-cpu_to_node.patch
mm-mempolicy-use-numa_node_id-instead-of-cpu_to_node-v3.patch
mm-numa_balancing-allow-migrate-on-protnone-reference-with-mpol_preferred_many-policy.patch

