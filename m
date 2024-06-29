Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E574D28E3
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628236; cv=none; b=bPE6DhXi3cZzxQ7kAkmh+e5HERcdiSATtiIvpNA+YyHUkgEry3OkUZHU3Retfb7A2vEH96vqqCxqPp4aOnBYiFQrLlKcyhS3J84u+XEhm9YzxKnhjkRsNzKEULN6az/3cSHaCrLEBuGyiZwflkwe82/0ge/09VTS5ycpv7CVBX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628236; c=relaxed/simple;
	bh=eg+NdOA85AZh9alviyYMRJ50xr+VD8YpVmWRXPvXEkU=;
	h=Date:To:From:Subject:Message-Id; b=dq+aFVOgsvivX4Vjhlk9FhjgdvPKqMZwbd9OmeN+WeGNFuPbebR7NEj+O2LXQrSZ1mrXS2PIsYkJFmY6gwht3om24Cb8pzj5i3p8SU8oNC4bBzL133f68n6aX2gEn8JfRT1euV3SUpbP8TgYxAh6wkhLSoPj7eh/Bq6HM7985Ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mGNKBgrj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mGNKBgrj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE0A7C116B1;
	Sat, 29 Jun 2024 02:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628235;
	bh=eg+NdOA85AZh9alviyYMRJ50xr+VD8YpVmWRXPvXEkU=;
	h=Date:To:From:Subject:From;
	b=mGNKBgrjyR0bDDPUaiZGkOGEe+N6Oc6JUoCpk/Bh9XQSLn5y+mrJg+SZV6dA9f2dq
	 DSembxaplpFKjhSARbiOV3gSkzeeaTSDdywmE75UfxeVCnb1t1/JwlB2Xor0trnbil
	 kPU6647lCQsOQrEqoGZjDjf5/E2pPTQ4M25WPgpA=
Date: Fri, 28 Jun 2024 19:30:35 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,svens@linux.ibm.com,rostedt@goodmis.org,roman.gushchin@linux.dev,rientjes@google.com,penberg@kernel.org,mhiramat@kernel.org,mark.rutland@arm.com,kasan-dev@googlegroups.com,iamjoonsoo.kim@lge.com,hca@linux.ibm.com,gor@linux.ibm.com,glider@google.com,elver@google.com,dvyukov@google.com,cl@linux.com,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,42.hyeyoo@gmail.com,iii@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kmsan-make-the-tests-compatible-with-kmsanpanic=1.patch removed from -mm tree
Message-Id: <20240629023035.BE0A7C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kmsan: make the tests compatible with kmsan.panic=1
has been removed from the -mm tree.  Its filename was
     kmsan-make-the-tests-compatible-with-kmsanpanic=1.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ilya Leoshkevich <iii@linux.ibm.com>
Subject: kmsan: make the tests compatible with kmsan.panic=1
Date: Fri, 21 Jun 2024 13:34:46 +0200

It's useful to have both tests and kmsan.panic=1 during development, but
right now the warnings, that the tests cause, lead to kernel panics.

Temporarily set kmsan.panic=0 for the duration of the KMSAN testing.

Link: https://lkml.kernel.org/r/20240621113706.315500-3-iii@linux.ibm.com
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: <kasan-dev@googlegroups.com>
Cc: Marco Elver <elver@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmsan/kmsan_test.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/kmsan/kmsan_test.c~kmsan-make-the-tests-compatible-with-kmsanpanic=1
+++ a/mm/kmsan/kmsan_test.c
@@ -686,9 +686,13 @@ static void test_exit(struct kunit *test
 {
 }
 
+static int orig_panic_on_kmsan;
+
 static int kmsan_suite_init(struct kunit_suite *suite)
 {
 	register_trace_console(probe_console, NULL);
+	orig_panic_on_kmsan = panic_on_kmsan;
+	panic_on_kmsan = 0;
 	return 0;
 }
 
@@ -696,6 +700,7 @@ static void kmsan_suite_exit(struct kuni
 {
 	unregister_trace_console(probe_console, NULL);
 	tracepoint_synchronize_unregister();
+	panic_on_kmsan = orig_panic_on_kmsan;
 }
 
 static struct kunit_suite kmsan_test_suite = {
_

Patches currently in -mm which might be from iii@linux.ibm.com are


