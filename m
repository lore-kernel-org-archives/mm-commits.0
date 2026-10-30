Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793377032;
	b=p6/SRT5NskhAudliD6XihA2HSY/l1YV09PCPoF35K8Uwjdb9N0cuYLwjgz4IMMe/Y7pU
	 T0sdtJGVLY16XWWQMb84bp76vqe1JL3n7mURPXg0F1FmPuU2zsBSnZi0+kxYczhTE82q6
	 tlGhbRUgaw8NPB58xdgcVprU/ThPO3XedH7IdtSa+rTFyrLjR0YDWDif6kTIkVcQdocVs
	 u/QRIS29LnyOvsWR7gA04ezqFBDp0tgySoj9+Y91RdPwRAu6Vn8PUKbfnbQSmO0I3Ghd/
	 WlRmZnGZblbZq+Vb+nh5ZM+arYnoM712MeNyQ9rl37mbXv+HAL94qXgDAchp+2NSLgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793377032;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=+dCl9TEGZ0Ek86ef494HY6gfebaJIs6yITZ/cbDWoFw=;
	b=FyhznpZQ/ePBr6JobSDc2SHFzbPjeY+c7A+SJKnM0U1mFYO7wXYMTJDzhxvwM7m0WUip
	 0BVPVpA8o6Jtq8CafsrfmL4vZLIQ5m1XbIJALZALPjmHFqtZCXX0ZDUNqrlOkQT2sBE96
	 nDOxyXSmMQnilbzHDtzSPyU0BbSN6qXxUcHeS/vLYhrGVmRPfiuCWnEoZuQGm2FWtyhte
	 LcP7qYamJ+EgXSKtXImlGfcau4DkgUGx8E1mw9NVzGaR5kut/xWhg15OVEbEhqFR6PZTO
	 ShvRo+F7ZXukNKq8ySZbIjcDTOIgjBVLlEUf9P+t0w/cm3K5tM19WjG2wM/QQ6mfMBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=MORHSQOw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A36F6606A31A;
	Fri, 30 Oct 2026 16:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=MORHSQOw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C39C1F000C1;
	Fri, 30 Oct 2026 16:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793377031;
	bh=+dCl9TEGZ0Ek86ef494HY6gfebaJIs6yITZ/cbDWoFw=;
	h=Date:To:From:Subject;
	b=MORHSQOw95leYUziJnIqiZJsher3pCBOB3KZ0H98bM4DNOGV6hlcPjS7QhKpZd8Cb
	 8yqIyxUy1ogZJ8AtNnWSYEfc0pClzQ5USoky/lJIQw3sETYVkZvgrdAB+ZJiM+77Ps
	 JYd03zhPlsp9jIJCPKZGCY9kb+iuYeQlRyM89VnM=
Date: Fri, 30 Oct 2026 09:17:10 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sashal@kernel.org,
	joe@perches.com,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] get_maintainer-lazy-load-json-pp-only-when-json-is-used.patch removed from -mm tree
Message-Id: <20261030161711.3C39C1F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: get_maintainer: lazy load JSON::PP only when --json is used
has been removed from the -mm tree.  Its filename was
     get_maintainer-lazy-load-json-pp-only-when-json-is-used.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: get_maintainer: lazy load JSON::PP only when --json is used
Date: Fri, 30 Oct 2026 16:43:48 +0100

After commit 09d8b39563e8 ("get_maintainer: add --json output mode"),
I can no longer use get_maintainer.pl; it fails at compile time if
JSON::PP is not installed even when --json is not requested.

This module is only needed with the --json option. Use "require" to
load this module dynamically inside the "if ($json)" block instead.

Link: https://lore.kernel.org/auS7NOsyw7pJ7rbF@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>
Cc: Sasha Levin <sashal@kernel.org>
Cc: <stable@vger.kernel.org>
---

 scripts/get_maintainer.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/get_maintainer.pl~get_maintainer-lazy-load-json-pp-only-when-json-is-used
+++ a/scripts/get_maintainer.pl
@@ -21,7 +21,6 @@ use Cwd;
 use File::Find;
 use File::Spec::Functions;
 use open qw(:std :encoding(UTF-8));
-use JSON::PP;
 
 my $cur_path = fastgetcwd() . '/';
 my $lk_path = "./";
@@ -685,6 +684,7 @@ if ($json) {
     $result{web} = \@web if ($web);
     $result{bug} = \@bug if ($bug);
 
+    require JSON::PP;
     my $json_encoder = JSON::PP->new->canonical->utf8;
     print($json_encoder->encode(\%result) . "\n");
 } else {
_

Patches currently in -mm which might be from oleg@redhat.com are

proc-use-pid_has_task-in-proc_inode_is_dead.patch

