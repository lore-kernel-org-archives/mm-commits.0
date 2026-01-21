Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1145B35F8C8
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768966114; cv=none; b=mKF8WQui8p7y9JT/IUQ3eZeqk5XbDyQkJfwjjhm9MaJjTJ9fxfzJ393KfcnywA/QKs5uXfb4i+qemMVBPK0ILb8UvubReP7/XYOs4WbaBqDu0VIEo1XrDOjWn+c2gcXaIbOcXwRhlhEOMB8/inETQqHFve7n6VmIS7eIfxSqmso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768966114; c=relaxed/simple;
	bh=V9RWKpNprks9ADOrZphL0gt9Y93wnJHYB+GAo7i9S0k=;
	h=Date:To:From:Subject:Message-Id; b=lIr41EGQgATFF98kCxfBGCXeDcQlEPoBT0V6fTbEhmm0i69C5TSwC0aBSrpYAwWl03iRV+UndUB3D5GQMQBqLPOxvz7f7v7B8f/e37GLhaqSvFkx1a6rJP3+bC+uiZAgsDmV0RbAkTDOBHSjI0K4NlFAGY/rPJQi7CsDTfg9T9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MTG3JTf+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MTG3JTf+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D22F4C16AAE;
	Wed, 21 Jan 2026 03:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768966113;
	bh=V9RWKpNprks9ADOrZphL0gt9Y93wnJHYB+GAo7i9S0k=;
	h=Date:To:From:Subject:From;
	b=MTG3JTf+KAKuKFMRdKteF8zqqYXNvGTwxnm/EoMlYJeRv3wgEARrfFGk06r1JdTXc
	 kRkXZ6p8GfzfRFbLufbQgbKiT0p7bk2VBAe5HN/q4GZXmaLliF4jbA07vswo6WKmLb
	 CEo7dMnVmnjzdfmA8UInu8djeSgTQ+dgCALl4IVQ=
Date: Tue, 20 Jan 2026 19:28:33 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,luizcap@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@kernel.org,chuhu@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-remove-arm64-nr_hugepages-setup-for-va_high_addr_switch-test.patch removed from -mm tree
Message-Id: <20260121032833.D22F4C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: remove arm64 nr_hugepages setup for va_high_addr_switch test
has been removed from the -mm tree.  Its filename was
     selftests-mm-remove-arm64-nr_hugepages-setup-for-va_high_addr_switch-test.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Chunyu Hu <chuhu@redhat.com>
Subject: selftests/mm: remove arm64 nr_hugepages setup for va_high_addr_switch test
Date: Sun, 21 Dec 2025 12:00:23 +0800

arm64 and x86_64 has the same nr_hugepages requriement for running the
va_high_addr_switch test.  Since commit d9d957bd7b61 ("selftests/mm: alloc
hugepages in va_high_addr_switch test"), the setup can be done in
va_high_addr_switch.sh.  So remove the duplicated setup.

Link: https://lkml.kernel.org/r/20251221040025.3159990-3-chuhu@redhat.com
Signed-off-by: Chunyu Hu <chuhu@redhat.com>
Reviewed-by: Luiz Capitulino <luizcap@redhat.com>
Cc: Luiz Capitulino <luizcap@redhat.com>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/run_vmtests.sh |    8 --------
 1 file changed, 8 deletions(-)

--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-remove-arm64-nr_hugepages-setup-for-va_high_addr_switch-test
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -412,15 +412,7 @@ if [ $VADDR64 -ne 0 ]; then
 	fi
 
 	# va high address boundary switch test
-	ARCH_ARM64="arm64"
-	prev_nr_hugepages=$(cat /proc/sys/vm/nr_hugepages)
-	if [ "$ARCH" == "$ARCH_ARM64" ]; then
-		echo 6 > /proc/sys/vm/nr_hugepages
-	fi
 	CATEGORY="hugevm" run_test bash ./va_high_addr_switch.sh
-	if [ "$ARCH" == "$ARCH_ARM64" ]; then
-		echo $prev_nr_hugepages > /proc/sys/vm/nr_hugepages
-	fi
 fi # VADDR64
 
 # vmalloc stability smoke test
_

Patches currently in -mm which might be from chuhu@redhat.com are


