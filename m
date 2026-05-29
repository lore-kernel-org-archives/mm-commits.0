Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66F4336C9DF
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780027556; cv=none; b=a+4Jdo4oLchvtIPJwl0GtwRVPMlZr+tRZMzKc1yiKv5eUFmq0FMBpUDjn6q3VcDAsVytfEwbjw7Wi1SR9i16sr1mUn51F26T/QaWbVuyS19qMCdG+1bPbmXRa9R5X1p3F7HMcYsE2VBxz03hMBddFo7G/u+kSiWMChWLy4eJ9ME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780027556; c=relaxed/simple;
	bh=YuBzhvI0FeP+63+nDCSjtxRDl2ANlRTLdKXtpjXE1H4=;
	h=Date:To:From:Subject:Message-Id; b=mrNiNU+GxnHFhjktYMCtXnrAPXmttYgxRwRkug7kBGdpONdDBr4c/fGN3CKlPB1bbg2x5miVjN+j95D/+CsGGiCbsIDYVQUMHuA4oOgLys+iGHWRYp2rYoTcOE3swPJn5u/kq5fpjfDmK/YoW8qxyVtnJd2zo9Ss1hCXIIQksl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BCqOHGcD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BCqOHGcD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DD821F00893;
	Fri, 29 May 2026 04:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780027555;
	bh=ywjVcy4w+nDAqODZo/16M4LR1GVY8QzDutbAS2+Kg80=;
	h=Date:To:From:Subject;
	b=BCqOHGcDODGJ9exqJKoCQ7VOSr6ON8ODf7O//WNbrK1ngyUqyId1XiQ8nEBFmnxZq
	 QnfFj9tFA144DsjpFvCQpJSLZjv6bR6+8bVPE2YQxn/Szeo32BPOPxrx49QYIePH1m
	 5deyRr+zoPopX1mRMMlusiW1rH6j4TEVTcNt56qg=
Date: Thu, 28 May 2026 21:05:54 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,david@kernel.org,akpm@linux-foundation.org,wangli.ahau@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-respect-build-verbosity-settings-for-32-64-bit-targets.patch removed from -mm tree
Message-Id: <20260529040555.1DD821F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: respect build verbosity settings for 32/64-bit targets
has been removed from the -mm tree.  Its filename was
     selftests-mm-respect-build-verbosity-settings-for-32-64-bit-targets.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Li Wang <wangli.ahau@gmail.com>
Subject: selftests/mm: respect build verbosity settings for 32/64-bit targets
Date: Wed, 22 Apr 2026 16:04:45 +0800

Patch series "selftests/mm: clean up build output and verbosity", v3.

Currently, the build process for the mm selftests is unnecessarily noisy.

First, it leaks raw compiler errors during the liburing feature probe if
the headers are missing, which is confusing since the build system already
handles this gracefully with a clear warning.

Second, the specific 32-bit and 64-bit compilation targets ignore the
standard kbuild verbosity settings, always printing their full compiler
commands even during a default quiet build.


This patch (of 2):

The 32-bit and 64-bit compilation rules invoke $(CC) directly, bypassing
the $(Q) quiet prefix and $(call msg,...) helper used by the rest of the
selftests build system.  This causes these rules to always print the full
compiler command line, even when V=0 (the default).

Wrap the commands with $(Q) and $(call msg,CC,,$@) to match the convention
used by lib.mk, so that quiet and verbose builds behave consistently
across all targets.

==== Build logs ====
  ...
  CC       merge
  CC       rmap
  CC       soft-dirty
  gcc -Wall -O2 -I /usr/src/25/tools/testing/selftests/../../..
                -isystem /usr/src/25/tools/testing/selftests/../../../usr/include
                -isystem /usr/src/25/tools/testing/selftests/../../../tools/include/uapi
                -Wunreachable-code -U_FORTIFY_SOURCE -no-pie -D_GNU_SOURCE=
                -I/usr/src/25/tools/testing/selftests/../../../tools/testing/selftests
                -m32 -mxsave  protection_keys.c vm_util.c thp_settings.c pkey_util.c
                -lrt -lpthread -lm -lrt -ldl -lm
                -o /usr/src/25/tools/testing/selftests/mm/protection_keys_32
  gcc -Wall -O2 -I /usr/src/25/tools/testing/selftests/../../..
                -isystem /usr/src/25/tools/testing/selftests/../../../usr/include
                -isystem /usr/src/25/tools/testing/selftests/../../../tools/include/uapi
                -Wunreachable-code -U_FORTIFY_SOURCE -no-pie -D_GNU_SOURCE=
                -I/usr/src/25/tools/testing/selftests/../../../tools/testing/selftests
                -m32 -mxsave  pkey_sighandler_tests.c vm_util.c thp_settings.c pkey_util.c
                -lrt -lpthread -lm -lrt -ldl -lm
                -o /usr/src/25/tools/testing/selftests/mm/pkey_sighandler_tests_32
  ...

Link: https://lore.kernel.org/20260422080446.26020-1-wangli.ahau@gmail.com
Link: https://lore.kernel.org/20260422080446.26020-2-wangli.ahau@gmail.com
Signed-off-by: Li Wang <wangli.ahau@gmail.com>
Reported-by: Andrew Morton <akpm@linux-foundation.org>
Tested-by: Andrew Morton <akpm@linux-foundation.org>
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

 tools/testing/selftests/mm/Makefile |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/Makefile~selftests-mm-respect-build-verbosity-settings-for-32-64-bit-targets
+++ a/tools/testing/selftests/mm/Makefile
@@ -216,7 +216,8 @@ ifeq ($(CAN_BUILD_I386),1)
 $(BINARIES_32): CFLAGS += -m32 -mxsave
 $(BINARIES_32): LDLIBS += -lrt -ldl -lm
 $(BINARIES_32): $(OUTPUT)/%_32: %.c
-	$(CC) $(CFLAGS) $(EXTRA_CFLAGS) $(notdir $^) $(LDLIBS) -o $@
+	$(call msg,CC,,$@)
+	$(Q)$(CC) $(CFLAGS) $(EXTRA_CFLAGS) $(notdir $^) $(LDLIBS) -o $@
 $(foreach t,$(VMTARGETS),$(eval $(call gen-target-rule-32,$(t))))
 endif
 
@@ -224,7 +225,8 @@ ifeq ($(CAN_BUILD_X86_64),1)
 $(BINARIES_64): CFLAGS += -m64 -mxsave
 $(BINARIES_64): LDLIBS += -lrt -ldl
 $(BINARIES_64): $(OUTPUT)/%_64: %.c
-	$(CC) $(CFLAGS) $(EXTRA_CFLAGS) $(notdir $^) $(LDLIBS) -o $@
+	$(call msg,CC,,$@)
+	$(Q)$(CC) $(CFLAGS) $(EXTRA_CFLAGS) $(notdir $^) $(LDLIBS) -o $@
 $(foreach t,$(VMTARGETS),$(eval $(call gen-target-rule-64,$(t))))
 endif
 
_

Patches currently in -mm which might be from wangli.ahau@gmail.com are


