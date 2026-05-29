Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37DD034D3B2
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780027558; cv=none; b=DQmZh2GgoNVjRproSBWvdl4ZK94Bgwfs8gS+QDcW0bRsPxT+GjGlkfWRo3216WKyI8lmjYaQGJJOadVVA2Zd8G8xiKO4SZwDmrdqe+KoDO++eQl2P51sjoJ+iNWb8tjqKuDv58ZeoOMvxzYGvmk1op13HjukFJW2JsOgyBC9uGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780027558; c=relaxed/simple;
	bh=6IsELoolEHQcgb8J0nc5/SX9zn0YH4u/k6MycduWeG8=;
	h=Date:To:From:Subject:Message-Id; b=Nc7qDofOj3IW95013nbZrQwjUj5LqqozxYJSDGG1XwRKqvN0fq/vnqqs9BEA2vEtw7rFk2zfNJyVgoKMLRtgdG4k9Txx/bHTz7HJOhK6mjAfMwo0ZupjK1go9Sw2rTxfBIDSAxbXYMKDY9vwaiDxPaM+pa5TeUhAVk+xbD1tHnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bvCqQnbW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bvCqQnbW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB5681F00893;
	Fri, 29 May 2026 04:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780027556;
	bh=+yivTM1FfJ2SKaElQ1YlFyUCaxzirsgS2POFAj8c784=;
	h=Date:To:From:Subject;
	b=bvCqQnbW3yBN5LlWsicbCOc08HGYgS0kFjGd+LVp5uoArsYMgPX73800ej1vpR/At
	 mOyZL+vxqFT0Hpu/EtbMoTkwHBy6Dg0qvzFl0f0ywcxfU11BjyRv0tnx2kuUO4sVQd
	 rPqsspHIKYHBOh3EEplmlGJZd0NrTfnXnbsORrCg=
Date: Thu, 28 May 2026 21:05:56 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,david@kernel.org,wangli.ahau@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-suppress-compiler-error-in-liburing-check.patch removed from -mm tree
Message-Id: <20260529040556.BB5681F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: suppress compiler error in liburing check
has been removed from the -mm tree.  Its filename was
     selftests-mm-suppress-compiler-error-in-liburing-check.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Li Wang <wangli.ahau@gmail.com>
Subject: selftests/mm: suppress compiler error in liburing check
Date: Wed, 22 Apr 2026 16:04:46 +0800

When building the mm selftests on a system without liburing development
headers, check_config.sh leaks a raw compiler error:

  /tmp/tmp.kIIOIqwe3n.c:2:10: fatal error: liburing.h: No such file or directory
      2 | #include <liburing.h>
        |          ^~~~~~~~~~~~

Since this is an expected failure during the configuration probe,
redirect the compiler output to /dev/null to hide it.

And the build system prints a clear warning when this occurs:

  Warning: missing liburing support. Some tests will be skipped.

Because the user is properly notified about the missing dependency, the
raw compiler error is redundant and only confuse users.

Additionally, update the Makefile to use $(Q) and $(call msg,...) for the
check_config.sh execution.  This aligns the probe with standard kbuild
output formatting, providing a clean "CHK" message instead of printing the
raw command during the build.

Link: https://lore.kernel.org/20260422080446.26020-3-wangli.ahau@gmail.com
Signed-off-by: Li Wang <wangli.ahau@gmail.com>
Tested-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/Makefile        |    3 ++-
 tools/testing/selftests/mm/check_config.sh |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/check_config.sh~selftests-mm-suppress-compiler-error-in-liburing-check
+++ a/tools/testing/selftests/mm/check_config.sh
@@ -16,7 +16,7 @@ echo "#include <sys/types.h>"        > $
 echo "#include <liburing.h>"        >> $tmpfile_c
 echo "int func(void) { return 0; }" >> $tmpfile_c
 
-$CC $CFLAGS -c $tmpfile_c -o $tmpfile_o
+$CC $CFLAGS -c $tmpfile_c -o $tmpfile_o >/dev/null 2>&1
 
 if [ -f $tmpfile_o ]; then
     echo "#define LOCAL_CONFIG_HAVE_LIBURING 1"  > $OUTPUT_H_FILE
--- a/tools/testing/selftests/mm/Makefile~selftests-mm-suppress-compiler-error-in-liburing-check
+++ a/tools/testing/selftests/mm/Makefile
@@ -263,7 +263,8 @@ $(OUTPUT)/migration: LDLIBS += -lnuma
 $(OUTPUT)/rmap: LDLIBS += -lnuma
 
 local_config.mk local_config.h: check_config.sh
-	CC="$(CC)" CFLAGS="$(CFLAGS)" ./check_config.sh
+	$(call msg,CHK,config,$@)
+	$(Q)CC="$(CC)" CFLAGS="$(CFLAGS)" ./check_config.sh
 
 EXTRA_CLEAN += local_config.mk local_config.h
 
_

Patches currently in -mm which might be from wangli.ahau@gmail.com are


