Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F1AF20101D
	for <mm-commits@vger.kernel.org>; Sun, 28 Sep 2025 18:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759084643; cv=none; b=RRAijTAlsHspbDAjnJkcTQDnD5z6pzga8mycttNrzAzquXnY/bByw2tgKoHJbtVfpP+12FBy+O1hoAHhHpCw2j3RhrWFLAMfV+o0P2quqkL2gKu6GHU8u9AQ1ZlA7zeWlIWLWUz8dW4HbdfQqmgkkF1zGGyfeapqbpH1l+cR88Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759084643; c=relaxed/simple;
	bh=ZlFhz9r7YX03h9nohzBvQn8XlcVhOywl2XDRlSbNKxI=;
	h=Date:To:From:Subject:Message-Id; b=oNsPM23o0JnZ5kgjX7Jpmfzm2ebR31vLOhoN+O9JLyl88bmHarA7yQ+Mui6z3QYOJ9YM0L+vbT1nc1TMgMspFQesQgabNoZV+MC+WMeWxIJMPaKw/daF8t1X8sjPJpAJ+cUf1ooWDdOY9g+2actqQbKEy8wpP//MrRgwEXMNJO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cJRau5Jl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cJRau5Jl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3723FC4CEF0;
	Sun, 28 Sep 2025 18:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759084643;
	bh=ZlFhz9r7YX03h9nohzBvQn8XlcVhOywl2XDRlSbNKxI=;
	h=Date:To:From:Subject:From;
	b=cJRau5Jl9Tv8OKXwxrbLTs3OWRX5JgdfMbqWtiFLO75NodOAMgV5Cz3UX4dyPbkbL
	 ia/MBrdYpdJXA5Yua+d/8FIKscBk83QD/OJn2LCFydoAXv8F46DSXdVpT/q69Vkusm
	 giy47SaffWV8BlmZ1XTiNnEpISqw4lZAnRnAHTRg=
Date: Sun, 28 Sep 2025 11:37:22 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,david.hunter.linux@gmail.com,chandna.linuxkernel@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kallsyms-use-kmalloc_array-instead-of-kmalloc.patch removed from -mm tree
Message-Id: <20250928183723.3723FC4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kallsyms: use kmalloc_array() instead of kmalloc()
has been removed from the -mm tree.  Its filename was
     kallsyms-use-kmalloc_array-instead-of-kmalloc.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sahil Chandna <chandna.linuxkernel@gmail.com>
Subject: kallsyms: use kmalloc_array() instead of kmalloc()
Date: Fri, 26 Sep 2025 13:20:53 +0530

Replace kmalloc(sizeof(*stat) * 2, GFP_KERNEL) with kmalloc_array(2,
sizeof(*stat), GFP_KERNEL) to prevent potential overflow, as recommended
in Documentation/process/deprecated.rst.

Link: https://lkml.kernel.org/r/20250926075053.25615-1-chandna.linuxkernel@gmail.com
Signed-off-by: Sahil Chandna <chandna.linuxkernel@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: David Hunter <david.hunter.linux@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kallsyms_selftest.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/kallsyms_selftest.c~kallsyms-use-kmalloc_array-instead-of-kmalloc
+++ a/kernel/kallsyms_selftest.c
@@ -264,7 +264,7 @@ static int test_kallsyms_basic_function(
 	char namebuf[KSYM_NAME_LEN];
 	struct test_stat *stat, *stat2;
 
-	stat = kmalloc(sizeof(*stat) * 2, GFP_KERNEL);
+	stat = kmalloc_array(2, sizeof(*stat), GFP_KERNEL);
 	if (!stat)
 		return -ENOMEM;
 	stat2 = stat + 1;
_

Patches currently in -mm which might be from chandna.linuxkernel@gmail.com are


