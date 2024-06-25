Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8E8D1442EA
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291696; cv=none; b=EpfjJZXeAEfhr3P5R6o6nzKxzAVyUth/ltYeFqvrUls4s8kPuwZO9U+lOSwuDZyjaqOTZd9z6mnbIFQAYKC0Xgci+S1ili2Ua1ujGvqCdquTS6DU5Nw0MjBnx5La4Hs8Fh1bc5YSJYdlIN9Q8Q8ExwrQeT9oZmj5j288XeASsAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291696; c=relaxed/simple;
	bh=6owp4z9VNCeexvIY0Yg0zoE5w7YNVxe3MmLqbUo2Odc=;
	h=Date:To:From:Subject:Message-Id; b=J7RRbCHY8puc5qAG/gwdUo39bMXcuedEP+LEVHn3OwtxDZMa3AAYBsL4J7RYfqTIdYmdjNSSQkFrzmMd8YLxp6EoIlMmG2eJpU6z9z3XtP+DF1a12GWG3cewXEH7ugQlQk3D3yEfvfRy93Shq4KMuoOx79mDhcuy5q57KybeSe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=INeSoeE3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="INeSoeE3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFA39C4AF09;
	Tue, 25 Jun 2024 05:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291695;
	bh=6owp4z9VNCeexvIY0Yg0zoE5w7YNVxe3MmLqbUo2Odc=;
	h=Date:To:From:Subject:From;
	b=INeSoeE3ZHIJAJkACBAECwxnMMxi6aA/kDE7XotFLx9bdVMfu6ULfDtK9Axigsbnd
	 ziZsUINJgQ0onxONJnn1Ee9GCHqSRVPp7C+gZ6HN6HokyU91CE6oHHX5Jput5dd52E
	 Km7j2NxrV5mkmRMv35vMNGco0o8TppxM0NfNzw94=
Date: Mon, 24 Jun 2024 22:01:35 -0700
To: mm-commits@vger.kernel.org,usama.anjum@collabora.com,shuah@kernel.org,ndesaulniers@google.com,nathan@kernel.org,morbo@google.com,justinstitt@google.com,cmllamas@google.com,edliaw@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-guard-defines-from-shm.patch removed from -mm tree
Message-Id: <20240625050135.BFA39C4AF09@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: guard defines from shm
has been removed from the -mm tree.  Its filename was
     selftests-mm-guard-defines-from-shm.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Edward Liaw <edliaw@google.com>
Subject: selftests/mm: guard defines from shm
Date: Wed, 5 Jun 2024 22:36:35 +0000

thuge-gen.c defines SHM_HUGE_* macros that are provided by the uapi since
4.14.  These macros get redefined when compiling with Android's bionic
because its sys/shm.h will import the uapi definitions.

However if linux/shm.h is included, with glibc, sys/shm.h will clash on
some struct definitions:

  /usr/include/linux/shm.h:26:8: error: redefinition of ‘struct shmid_ds’
     26 | struct shmid_ds {
        |        ^~~~~~~~
  In file included from /usr/include/x86_64-linux-gnu/bits/shm.h:45,
                   from /usr/include/x86_64-linux-gnu/sys/shm.h:30:
  /usr/include/x86_64-linux-gnu/bits/types/struct_shmid_ds.h:24:8: note: originally defined here
     24 | struct shmid_ds
        |        ^~~~~~~~

For now, guard the SHM_HUGE_* defines with ifndef to prevent redefinition
warnings on Android bionic.

Link: https://lkml.kernel.org/r/20240605223637.1374969-3-edliaw@google.com
Signed-off-by: Edward Liaw <edliaw@google.com>
Reviewed-by: Carlos Llamas <cmllamas@google.com>
Reviewed-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Bill Wendling <morbo@google.com>
Cc: Carlos Llamas <cmllamas@google.com>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/thuge-gen.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/tools/testing/selftests/mm/thuge-gen.c~selftests-mm-guard-defines-from-shm
+++ a/tools/testing/selftests/mm/thuge-gen.c
@@ -34,10 +34,18 @@
 #endif
 
 #define SHM_HUGETLB     04000   /* segment will use huge TLB pages */
+#ifndef SHM_HUGE_SHIFT
 #define SHM_HUGE_SHIFT  26
+#endif
+#ifndef SHM_HUGE_MASK
 #define SHM_HUGE_MASK   0x3f
+#endif
+#ifndef SHM_HUGE_2MB
 #define SHM_HUGE_2MB    (21 << SHM_HUGE_SHIFT)
+#endif
+#ifndef SHM_HUGE_1GB
 #define SHM_HUGE_1GB    (30 << SHM_HUGE_SHIFT)
+#endif
 
 #define NUM_PAGESIZES   5
 #define NUM_PAGES 4
_

Patches currently in -mm which might be from edliaw@google.com are


