Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795329759;
	b=wRXQxeJ5PchP9je3L3rN15I3QIbYoh108MEiL0XM8Vi6i71ymG3iDvKbq2YOa4IRIEtn
	 PVHmyCAY7sF9pcjwzoqRV1Mjk+Dty8dWHQgvi+pM/Vg8yNnEycQwTzuFhdApBBEy8IZUd
	 j7nri7i8Uaix3KQnuGX09FwX1Y1/kGWgpdRkYJbkD21dnUFq0gvNH9gOsKFroYJsNJGIJ
	 SdgbMrYuRodVj+WKSZRv0h+87dHEL8H4pq5erKvEA43AgxtmmhMPZk/xESlB73Lul7zvt
	 JrbkmiFrCfu5dfJMnsDNavHs9KqzVvy/ML2fi68J2t80/EU0f00DNvLJKPegwrigcEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795329759;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=YQHL6+IbEkq+xZuvB3SFkvMLFuXR571jONFkvLxD+kc=;
	b=zxepT/gOQjqC6uJwza/ejDm0F0mO6WyRLvEVaoKjeOjX3XvEv56AI+DY09mO2tptaa6A
	 GXCjeUaFce8QfHJIm9ygjveaQTFpZZYfEqt2ZcU5J69d+GEPZPYqe2SEV4WrZFlc2rieU
	 0YpYufL846oM8oSQ9bz0kIXsmQyngXRWWU0f5ayOCITUHS+XvNMGmL7G4vguvBfIxGbdB
	 WAtnLxCWio7nLXyEV+3s8eH2HPBvMbbFrslVqU9y+GoUNQV1UJzQcOrga9e2+sRDuVHWI
	 5Jqv09o2vpiq/uiZH4iHUBT/iosoDnV1sksX4A07EZZeIenhPOp2MDWKcuX1xL25Lxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=R9laAAcW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67FBF606A32A
	for <mm-commits@vger.kernel.org>; Sun, 22 Nov 2026 06:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=R9laAAcW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEB021F000D1;
	Sun, 22 Nov 2026 06:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795329758;
	bh=YQHL6+IbEkq+xZuvB3SFkvMLFuXR571jONFkvLxD+kc=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=R9laAAcWuPNoAkwPgbcemAONBz/n5onTKnFU9BS7giUYJB0Fm3QpyStgfo9bujrIK
	 KMKVVvpSfugbV9sUA+s2PkZtE40w+So9iKfZCY+1h2ODZwj4lCWU/E9ePcqiwNuCkg
	 uEBAev2lNwtVhiqlXwvdx3Pu5AvEVc6A06M3r5HY=
Date: Sat, 21 Nov 2026 22:42:38 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,hughd@google.com,
	david@kernel.org,baolin.wang@linux.alibaba.com,
	zhangchujun@cmss.chinamobile.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261113071306.1673-1-zhangchujun@cmss.chinamobile.com>
References: <20261113071306.1673-1-zhangchujun@cmss.chinamobile.com>
Subject: + selftests-memfd-close-fd-in-sysctl-helpers.patch added to mm-unstable branch
Message-Id: <20261122064238.CEB021F000D1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: selftests/memfd: close fd in sysctl helpers
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-memfd-close-fd-in-sysctl-helpers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-memfd-close-fd-in-sysctl-helpers.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Zhang Chujun <zhangchujun@cmss.chinamobile.com>
Subject: selftests/memfd: close fd in sysctl helpers
Date: Fri, 13 Nov 2026 15:13:06 +0800

The three sysctl helpers sysctl_assert_write(), sysctl_fail_write()
and sysctl_assert_equal() open /proc/sys/vm/memfd_noexec but never
close the descriptor, leaking one fd on every call.  The noexec tests
call these helpers in a loop, so the test can run out of file
descriptors on a system with a low limit.

Close the fd before returning from each helper.

Link: https://patch.msgid.link/20261113071306.1673-1-zhangchujun@cmss.chinamobile.com
Fixes: 6469b66e3f5a ("selftests: improve vm.memfd_noexec sysctl tests")
Signed-off-by: Zhang Chujun <zhangchujun@cmss.chinamobile.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Shuah Khan <shuah@kernel.org>

 tools/testing/selftests/memfd/memfd_test.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/tools/testing/selftests/memfd/memfd_test.c~selftests-memfd-close-fd-in-sysctl-helpers
+++ a/tools/testing/selftests/memfd/memfd_test.c
@@ -126,6 +126,8 @@ static void sysctl_assert_write(const ch
 		printf("write sysctl %s failed: %m\n", val);
 		abort();
 	}
+
+	close(fd);
 }
 
 static void sysctl_fail_write(const char *val)
@@ -142,6 +144,8 @@ static void sysctl_fail_write(const char
 				val);
 		abort();
 	}
+
+	close(fd);
 }
 
 static void sysctl_assert_equal(const char *val)
@@ -159,6 +163,8 @@ static void sysctl_assert_equal(const ch
 		abort();
 	}
 
+	close(fd);
+
 	/* Strip trailing whitespace. */
 	p = buf;
 	while (!isspace(*p))
_

Patches currently in -mm which might be from zhangchujun@cmss.chinamobile.com are

mm-page_owner-use-%u-to-print-the-stack-depot-handle.patch
selftests-cgroup-test_zswap-check-malloc-return-value.patch
selftests-memfd-close-fd-in-sysctl-helpers.patch

