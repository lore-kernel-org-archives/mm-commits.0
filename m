Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 702647603F
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714103844; cv=none; b=MqMPd6wA+vh0RqVfoDwfT26Gt6Ajz++gUuyGi/Ggh5JNiOAsFGbyUdl1lZzixssq6JvVzAqHYBUPuQCkrTaXlIAomOr4spPHuw6lPiBOknoLYfmebYquKE2MjKTxGvyFZrSpHHkOOAvpR8hoKkd4nr4yu54bCkeZqZQwzc8YdnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714103844; c=relaxed/simple;
	bh=HZuhabUb1mnIMePBlpm8wibCq6OhT8a5pLtc4fDs7HE=;
	h=Date:To:From:Subject:Message-Id; b=KqLXSyfi1XBKYWLgymaWIwFFdku+3Az0WsR1CaH3CtnQmA/sEpF3+K8vZgZp9ql0+1leZg+XIaoPz5CC2dAw5tVRxlnS8oDfHYyz9JQHre3UkGtxGZSnOOu1qEl/QNLrn/h+Fx/e22MS0z6kNYr3zZdxYPa+FjfIt+vA7hUC6xM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jLcPFR7F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jLcPFR7F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8867C113CD;
	Fri, 26 Apr 2024 03:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714103844;
	bh=HZuhabUb1mnIMePBlpm8wibCq6OhT8a5pLtc4fDs7HE=;
	h=Date:To:From:Subject:From;
	b=jLcPFR7Fr/1bHRNRTiinvhEKFTKXiz2PP19amHeifLCQ4fnGRk6mpEiBK1sL2fJxU
	 jvBmRPJy+U5OaqMehfA6QXReHpZ2ThWsUM8CWGAgFqw72tg0xcsfu2oXX2FdDVCTSh
	 A3vwthM1BZ9rJR9IY5xzsLtKql0rX6x+PpKDXGiw=
Date: Thu, 25 Apr 2024 20:57:23 -0700
To: mm-commits@vger.kernel.org,usama.anjum@collabora.com,shuah@kernel.org,anshuman.khandual@arm.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-virtual_address_range-switch-to-ksft_exit_fail_msg.patch removed from -mm tree
Message-Id: <20240426035723.E8867C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: virtual_address_range: Switch to ksft_exit_fail_msg
has been removed from the -mm tree.  Its filename was
     selftests-mm-virtual_address_range-switch-to-ksft_exit_fail_msg.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dev Jain <dev.jain@arm.com>
Subject: selftests/mm: virtual_address_range: Switch to ksft_exit_fail_msg
Date: Thu, 14 Mar 2024 17:52:50 +0530

mmap() must not succeed in validate_lower_address_hint(), for if it does,
it is a bug in mmap() itself.  Reflect this behaviour with
ksft_exit_fail_msg().  While at it, do some formatting changes.

Link: https://lkml.kernel.org/r/20240314122250.68534-1-dev.jain@arm.com
Signed-off-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/virtual_address_range.c |   12 ++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/tools/testing/selftests/mm/virtual_address_range.c~selftests-mm-virtual_address_range-switch-to-ksft_exit_fail_msg
+++ a/tools/testing/selftests/mm/virtual_address_range.c
@@ -85,7 +85,7 @@ static int validate_lower_address_hint(v
 	char *ptr;
 
 	ptr = mmap((void *) (1UL << 45), MAP_CHUNK_SIZE, PROT_READ |
-			PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+		   PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
 
 	if (ptr == MAP_FAILED)
 		return 0;
@@ -105,13 +105,11 @@ int main(int argc, char *argv[])
 
 	for (i = 0; i < NR_CHUNKS_LOW; i++) {
 		ptr[i] = mmap(NULL, MAP_CHUNK_SIZE, PROT_READ | PROT_WRITE,
-					MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+			      MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
 
 		if (ptr[i] == MAP_FAILED) {
-			if (validate_lower_address_hint()) {
-				ksft_test_result_skip("Memory constraint not fulfilled\n");
-				ksft_finished();
-			}
+			if (validate_lower_address_hint())
+				ksft_exit_fail_msg("mmap unexpectedly succeeded with hint\n");
 			break;
 		}
 
@@ -127,7 +125,7 @@ int main(int argc, char *argv[])
 	for (i = 0; i < NR_CHUNKS_HIGH; i++) {
 		hint = hind_addr();
 		hptr[i] = mmap(hint, MAP_CHUNK_SIZE, PROT_READ | PROT_WRITE,
-					MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+			       MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
 
 		if (hptr[i] == MAP_FAILED)
 			break;
_

Patches currently in -mm which might be from dev.jain@arm.com are


