Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24DE22C11D4
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489999; cv=none; b=PA5PcdAZmrqaGTwk2nDx1LoCZaLCc1ropvaOCNXHRCZQClQ6R8Il8ASQGUcUsoB0VJSIwqkUrVoATF/f6reFIxXW5d/6LRnnekm5zLmEzdk9Z1S+tUZ0HCbfwAVZvgn6dfxb6B9LUf8N6z2nCH0thNdLf86UrnUVygoN1Gbnl7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489999; c=relaxed/simple;
	bh=odbcgsTBnCUbE3bJXw7PeockxsxNZm5SCaRk9hTakZw=;
	h=Date:To:From:Subject:Message-Id; b=nL1HTla5BQskAZzhthnsohdw26ko3fwRSF2FLF6O/nKRyDakf1VPNsXro/Rq3jjUMvuXUHk8CckF7X3vm1rk4qqGOtpJ9+MTOH5LYm81I8ySVU7WzRWJ+BJwlwRsTnurpikWfhc3TAxTEIXn3wleEXfF0+FGpyxfHGnRE7bket8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CislxugD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CislxugD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC77FC4CEE7;
	Sun, 21 Sep 2025 21:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489999;
	bh=odbcgsTBnCUbE3bJXw7PeockxsxNZm5SCaRk9hTakZw=;
	h=Date:To:From:Subject:From;
	b=CislxugDMqp7DwK5wTLpMX288v6ZWq1xud0eMEFYMs67kpArsyt0qTDsSwLUgHrZ2
	 Xcs4ewRvwk0nHSWrIerpZdt1dY/ZZ0Kmo4eGhZDgzADqUJw/G3Fjcbd77szXt9NOL9
	 H1Ozv6nUeD7vv4ZiJuqb1IQszSOO9T3IAl1U5QFE=
Date: Sun, 21 Sep 2025 14:26:38 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,sd@queasysnail.net,rppt@kernel.org,pabeni@redhat.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kuba@kernel.org,horms@kernel.org,edumazet@google.com,david@redhat.com,davem@davemloft.net,antonio@openvpn.net,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-centralize-the-__always_unused-macro.patch removed from -mm tree
Message-Id: <20250921212638.EC77FC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: centralize the __always_unused macro
has been removed from the -mm tree.  Its filename was
     selftests-mm-centralize-the-__always_unused-macro.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


