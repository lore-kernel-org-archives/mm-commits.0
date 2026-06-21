Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BB4D36F8F0
	for <mm-commits@vger.kernel.org>; Sun, 21 Jun 2026 18:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782067187; cv=none; b=H923zFQwxlpsuOnEnKlOD3kcmn+dHCOprNt2M+sRHNCsenfsBQn6Ydceb3qS56HzfzyCmZ5T3N1ire9IsxxVw3tG7mqJAs7Vlkf73I97vmJQQ1pk6f5wYin3cB2CSnGTS/45EjKzK2lq3dQuYcrpDDDTj1feSMVr+kqnJFYhOyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782067187; c=relaxed/simple;
	bh=/74Q+vrdyrFeSUQYKIoXXIZZ9D1YNo1R9PeHM6I52Vk=;
	h=Date:To:From:Subject:Message-Id; b=OGal/N9Id+1qagmBGIIsALiag2DxXf3JGmTx3Ivui2pVLC1ZMNgL2AyK5xk25AWKy6hYT6yWyabpG3k9XzFzOgTqKpKCPCvfiiyPQTK/rxSkWood3l2tl3WrYuLXWw5CJu/Ol9vka8mc3UNq9YuI466MigpH5EyV9Y0kodKA7BY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=V41gdJZP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="V41gdJZP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75B101F000E9;
	Sun, 21 Jun 2026 18:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782067186;
	bh=dDFyPfwJ7wluhhv5JJncy4R9+rnTfQjKjeUWTkeTIwI=;
	h=Date:To:From:Subject;
	b=V41gdJZP/iScwKPtRE2txSO4CMElskHQoXeGVdMeqzMvBtQN/71smXmwlpTusOypH
	 KeiXNzczoDGbHPYcE44mnQ84TvJcM/ea12FhlhSHlg9Gqba6ibHKjEuJkDQhL6V72S
	 D5PQeRVCBVwuehlDlAp1X3YVI4WAGsDj4xVfW6V0=
Date: Sun, 21 Jun 2026 11:39:46 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,sarthak.sharma@arm.com,ryan.roberts@arm.com,peterx@redhat.com,npache@redhat.com,mhocko@suse.com,luizcap@redhat.com,ljs@kernel.org,li.wang@linux.dev,liam@infradead.org,leon@kernel.org,lance.yang@linux.dev,jhubbard@nvidia.com,jgg@ziepe.ca,donettom@linux.ibm.com,dev.jain@arm.com,david@kernel.org,broonie@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-va_high_addr_switchsh-drop-huge-pages-setup.patch removed from -mm tree
Message-Id: <20260621183946.75B101F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: va_high_addr_switch.sh: drop huge pages setup
has been removed from the -mm tree.  Its filename was
     selftests-mm-va_high_addr_switchsh-drop-huge-pages-setup.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: selftests/mm: va_high_addr_switch.sh: drop huge pages setup
Date: Mon, 11 May 2026 19:28:37 +0300

Since va_high_addr_switch takes care of setting up huge pages, there is no
need to set them up in the va_high_addr_switch.sh wrapper script.

Link: https://lore.kernel.org/20260511162840.375890-54-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Luiz Capitulino <luizcap@redhat.com>
Tested-by: Luiz Capitulino <luizcap@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Donet Tom <donettom@linux.ibm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Liam Howlett <liam@infradead.org>
Cc: Li Wang <li.wang@linux.dev>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/va_high_addr_switch.sh |   41 ------------
 1 file changed, 1 insertion(+), 40 deletions(-)

--- a/tools/testing/selftests/mm/va_high_addr_switch.sh~selftests-mm-va_high_addr_switchsh-drop-huge-pages-setup
+++ a/tools/testing/selftests/mm/va_high_addr_switch.sh
@@ -9,7 +9,6 @@
 
 # Kselftest framework requirement - SKIP code is 4.
 ksft_skip=4
-orig_nr_hugepages=0
 
 skip()
 {
@@ -77,43 +76,5 @@ check_test_requirements()
 	esac
 }
 
-save_nr_hugepages()
-{
-	orig_nr_hugepages=$(cat /proc/sys/vm/nr_hugepages)
-}
-
-restore_nr_hugepages()
-{
-	echo "$orig_nr_hugepages" > /proc/sys/vm/nr_hugepages
-}
-
-setup_nr_hugepages()
-{
-	local needpgs=$1
-	while read -r name size unit; do
-		if [ "$name" = "HugePages_Free:" ]; then
-			freepgs="$size"
-			break
-		fi
-	done < /proc/meminfo
-	if [ "$freepgs" -ge "$needpgs" ]; then
-		return
-	fi
-	local hpgs=$((orig_nr_hugepages + needpgs))
-	echo $hpgs > /proc/sys/vm/nr_hugepages
-
-	local nr_hugepgs=$(cat /proc/sys/vm/nr_hugepages)
-	if [ "$nr_hugepgs" != "$hpgs" ]; then
-		restore_nr_hugepages
-		skip "$0: no enough hugepages for testing"
-	fi
-}
-
 check_test_requirements
-save_nr_hugepages
-# The HugeTLB tests require 6 pages
-setup_nr_hugepages 6
-./va_high_addr_switch --run-hugetlb
-retcode=$?
-restore_nr_hugepages
-exit $retcode
+./va_high_addr_switch
_

Patches currently in -mm which might be from rppt@kernel.org are


