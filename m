Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 521102DC789
	for <mm-commits@vger.kernel.org>; Fri, 12 Sep 2025 22:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757717375; cv=none; b=RmLREg9k+NG1uXcdxt7wz4BqzoOIXBlWKXnQIjadCvwyrCu4MplMPNAag3oriBWUNOgTzUI5QZ7YYk6LR+Zxdl5MaunQwgExZBLJIF3kq6sN4aGMbrSvBUsIytUYez6JLYpyC3taLz4AYW9LOD3Bs6fX0nxp5T0Oh0Qt0l38FXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757717375; c=relaxed/simple;
	bh=ZaH6nXoJGODplYMIE/2uFDHNUhfvJ0Cvj5Dnt7V/UuU=;
	h=Date:To:From:Subject:Message-Id; b=fyp7V8b8q4XE//PGSE5lXwIjySwE2eH72AuNg8+pvPUvkbRDJ5U49i1eMCwDtrMrIUX0iKswjaNhE8wpJ58AlegQO2LXDHJ9D0yPObuGKU40FZb85SoS85rZ8jggDSsb/evbzOn5/BqsZDMmxZygWFGNJceXKPCGqIzI6Ddnuzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HIALLeDG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HIALLeDG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B3BCC4CEF5;
	Fri, 12 Sep 2025 22:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757717374;
	bh=ZaH6nXoJGODplYMIE/2uFDHNUhfvJ0Cvj5Dnt7V/UuU=;
	h=Date:To:From:Subject:From;
	b=HIALLeDG6WIOr2XpIAZ2caDp+ZN0pPkUsesVbeyNCntTI39YQh7Os9QHWYaP/2VKx
	 tfO5PiNCuROXLyPn/FKyb8kqG70TeMhvKTLBOF5Eyq1FE1i40ityRC/nS99+hxXtVi
	 kZshb8jL6+Ym8JcSBMZoSZazmco5YGeUQ5xY+N0I=
Date: Fri, 12 Sep 2025 15:49:34 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,sd@queasysnail.net,rppt@kernel.org,pabeni@redhat.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kuba@kernel.org,horms@kernel.org,edumazet@google.com,david@redhat.com,davem@davemloft.net,antonio@openvpn.net,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-centralize-the-__always_unused-macro.patch added to mm-new branch
Message-Id: <20250912224934.9B3BCC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: centralize the __always_unused macro
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-centralize-the-__always_unused-macro.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-centralize-the-__always_unused-macro.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
Subject: selftests/mm: centralize the __always_unused macro
Date: Fri, 12 Sep 2025 17:51:01 +0500

This macro gets used in different tests.  Add it to kselftest.h which is
central location and tests use this header.  Then use this new macro.

Link: https://lkml.kernel.org/r/20250912125102.1309796-1-usama.anjum@collabora.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Antonio Quartulli <antonio@openvpn.net>
Cc: David S. Miller <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kacinski <kuba@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: "Sabrina Dubroca" <sd@queasysnail.net>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Simon Horman <horms@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/kselftest.h          |    4 ++++
 tools/testing/selftests/mm/protection_keys.c |    2 +-
 tools/testing/selftests/net/ovpn/ovpn-cli.c  |    3 ++-
 3 files changed, 7 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/kselftest.h~selftests-mm-centralize-the-__always_unused-macro
+++ a/tools/testing/selftests/kselftest.h
@@ -92,6 +92,10 @@
 #endif
 #define __printf(a, b)   __attribute__((format(printf, a, b)))
 
+#ifndef __always_unused
+#define __always_unused __attribute__((__unused__))
+#endif
+
 #ifndef __maybe_unused
 #define __maybe_unused __attribute__((__unused__))
 #endif
--- a/tools/testing/selftests/mm/protection_keys.c~selftests-mm-centralize-the-__always_unused-macro
+++ a/tools/testing/selftests/mm/protection_keys.c
@@ -1304,7 +1304,7 @@ static void test_mprotect_with_pkey_0(in
 
 static void test_ptrace_of_child(int *ptr, u16 pkey)
 {
-	__attribute__((__unused__)) int peek_result;
+	__always_unused int peek_result;
 	pid_t child_pid;
 	void *ignored = 0;
 	long ret;
--- a/tools/testing/selftests/net/ovpn/ovpn-cli.c~selftests-mm-centralize-the-__always_unused-macro
+++ a/tools/testing/selftests/net/ovpn/ovpn-cli.c
@@ -32,9 +32,10 @@
 
 #include <sys/socket.h>
 
+#include "../../kselftest.h"
+
 /* defines to make checkpatch happy */
 #define strscpy strncpy
-#define __always_unused __attribute__((__unused__))
 
 /* libnl < 3.5.0 does not set the NLA_F_NESTED on its own, therefore we
  * have to explicitly do it to prevent the kernel from failing upon
_

Patches currently in -mm which might be from usama.anjum@collabora.com are

selftests-mm-centralize-the-__always_unused-macro.patch

