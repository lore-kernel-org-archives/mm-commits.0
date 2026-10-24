Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832320;
	b=s4ied3Pd450z1PGXulpnCd1dQpUO7EPG+449YKOzKG3RQAi6LsjPCV90KK9g8X31Oao6
	 4abXUzBJv6DqwmGV9R/eo1qjSrD9JPE3eBcGcs44S3AcsuX96NdNgbXaLGi007VKkjnET
	 xEDpOrBoYUAb/OQPGlhhysxk3wCkokZ34p+YmTMEi9DIDfjrW4oQg4CTTY6zJdCYm7Oom
	 6iNqtFnkiubO1WgHMby0d+wDojxEGhXbhfdK8NBMPOp2JL8xd56SyFy7bvMuJg0Tv/Jin
	 xO6TSFa2CZtKD9OkpUq6lfJmP4yMLeNgYqSWdqUXS4VaSkUoMQ+UzvMEg9TMqxU914Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832320;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=8ireJv1QulqZqpaen3zcPItkhNhDBnYJcVvNHKOoSag=;
	b=VQpQ086kNmLZ1A4ErACwRAECG2c9gy7BkqJPPjnMCdprYDPMbidCgUPSGLFDMgS7BQ/9
	 C6+okk6kHAVIhYvmSZ09aAcVnh8JPf1JgCDJjfJRxCUGJ/4u1DMP0G3DuYwT+BqNQ0p8q
	 Nd9G0IMLyu/EzAdzJmo6DYh7VdEQ2cL5g78yntKvtJLLhKydgkbOc1fg+LAf3J6iJmc3r
	 MPvX9Y8Y4/SbFcVrfscBVqfLGDr5sMhgNSupQINCo3puiBAdg8a7tXNwGhiGpuIzMFf2W
	 b0pe1WCb+EfLIl07/vdVdFvCfP0qD9Sh0m7UCOueYRq21XT4i7DmCO1IBodUAXBoSgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=wZqTfQnd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5FF1606A31D
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 08:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=wZqTfQnd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F62B1F01828;
	Sat, 24 Oct 2026 08:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832319;
	bh=8ireJv1QulqZqpaen3zcPItkhNhDBnYJcVvNHKOoSag=;
	h=Date:To:From:Subject;
	b=wZqTfQndNkyi6vORuNwMBKiCRNtd1XD46jL7Ar99BkrgYJPQKpnDaxKHcqUOwKGFa
	 lI4gmmSGnvswZMtLrpC9Wu1297aalKKFyWFK0Ue0MOV8U3ADlPBlB/SKE/hP8JdO/S
	 nvvDZJVKWQBqveLRahqQeL9Fut7GKeeOsXWtG2VU=
Date: Sat, 24 Oct 2026 01:58:39 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-sysfssh-test-quota-goal-complement-flag-file.patch removed from -mm tree
Message-Id: <20261024085839.8F62B1F01828@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: selftests/damon/sysfs.sh: test quota goal complement flag file
has been removed from the -mm tree.  Its filename was
     selftests-damon-sysfssh-test-quota-goal-complement-flag-file.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: selftests/damon/sysfs.sh: test quota goal complement flag file
Date: Tue, 29 Sep 2026 01:01:08 -0700

Test the existence and the valid input acceptance of the newly added
quota goal complement flag sysfs file.

Link: https://lore.kernel.org/20260929080113.41708-6-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Shuah Khan <shuah@kernel.org>
---

 tools/testing/selftests/damon/sysfs.sh |    3 +++
 1 file changed, 3 insertions(+)

--- a/tools/testing/selftests/damon/sysfs.sh~selftests-damon-sysfssh-test-quota-goal-complement-flag-file
+++ a/tools/testing/selftests/damon/sysfs.sh
@@ -212,6 +212,9 @@ test_goal()
 	ensure_write_succ "$fpath" "node_eligible_mem_bp" "valid input"
 	ensure_write_succ "$fpath" "hugepage_mem_bp" "valid input"
 	ensure_write_fail "$fpath" "foo" "invalid input"
+	ensure_file "$goal_dir/complement" "exist" "600"
+	ensure_write_succ "$goal_dir/complement" "Y" "valid input"
+	ensure_write_succ "$goal_dir/complement" "N" "valid input"
 	ensure_file "$goal_dir/nid" "exist" "600"
 	ensure_file "$goal_dir/path" "exist" "600"
 }
_

Patches currently in -mm which might be from sj@kernel.org are


