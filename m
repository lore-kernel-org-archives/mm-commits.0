Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794545806;
	b=NHPpA5gBluQL2ZDEuetFEgZjblKO8mcZDlNMkNrwIo6KmrqFD3TB+2RBSaSsYmix6FOA
	 LCvIytDeVI2d2iklAPuP/rRZxcZRBiJ3laR2tmlsQzyQCENOd243cU+gRSzkqt6EjTjoK
	 mVz1CAB7YR9NC8LMVx+qL0oametecjqSemJcRRz2iqP/et4zmjXuFXQuKbMlmNYjhXEmw
	 tLcjw/j/6hWMerqmKBeB8YN92uJOjD5yVHxF6sRiUWbf7C+VomP/Nr4757bFj3s1LIAXd
	 Y7ze4f98dTynu9wpTaovqFBsc7l0w/5Ihaoh5664iOFA2UCYVyaJYUBWm0C8UfIeoiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794545806;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=ugi4XyiyWwcvnRfoED9cjV5fXP5hPS97szZ9XwE0AKU=;
	b=MmB1zU1gv1eohbQEBn5TNC9aIwoGswsvWNq2DH+3/RLm6z86CYmDDhoebA6Xz5pLrL5s
	 4LmOu7LgpXh3UThxweGQdW9zbZ6BJlSQCsLluW9tOw6IArbHtlPN3MzsWoP5/6LdZInn9
	 zH18W3rjVxXr3h3tAIy8ZPU7A+fLzu8qvCYbsvAjwiACJsF2VFn+6AAmOFji6cE3ycedK
	 WzmVZpQz2t14XrgmZjT0OrANVwRA6udybyB60gAGWBRIi6FnwGXl0n+sG9aGomEaSuA7l
	 xelnlej7mkI37yHvFqb98G49pAbNeHl0P6TZjbIqiIQwI7xWI32hNchSNLK5CQoUEHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=BtEvlQsf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBD1F606A31C
	for <mm-commits@vger.kernel.org>; Fri, 13 Nov 2026 04:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=BtEvlQsf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 465E21F000C4;
	Fri, 13 Nov 2026 04:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794545806;
	bh=ugi4XyiyWwcvnRfoED9cjV5fXP5hPS97szZ9XwE0AKU=;
	h=Date:To:From:Subject;
	b=BtEvlQsf4U3DPS921Mz6fISXViNxmJPbaVk1BIsmhGwdMe9uSdn6eTBmJrZSiJAWa
	 TWCllHad1s9KqP6gVFMg0EH8jfeeiXSt0eDfD9yMcU/H+Dcji2gQw37863tZx9Y9PV
	 AXh6aP1JKDJJD5Gj1B9TYgLRFYr3z3OafwoZ4s20=
Date: Thu, 12 Nov 2026 20:56:45 -0800
To: mm-commits@vger.kernel.org,joe@perches.com,elver@google.com,
	dwaipayanray1@gmail.com,apw@canonical.com,vdonnefort@google.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] checkpatch-add-context-analysis-attributes.patch removed from -mm tree
Message-Id: <20261113045646.465E21F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: checkpatch: add context-analysis attributes
has been removed from the -mm tree.  Its filename was
     checkpatch-add-context-analysis-attributes.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Vincent Donnefort <vdonnefort@google.com>
Subject: checkpatch: add context-analysis attributes
Date: Thu, 12 Nov 2026 15:12:03 +0000

Checkpatch doesn't know about the context analysis attributes and
misparses annotated declarations (e.g.  mistaking __guarded_by() fields
for extern prototype).  Add them to the known attributes list.

Link: https://lore.kernel.org/20261112151203.3129005-1-vdonnefort@google.com
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Marco Elver <elver@google.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Joe Perches <joe@perches.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
---

 scripts/checkpatch.pl |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/scripts/checkpatch.pl~checkpatch-add-context-analysis-attributes
+++ a/scripts/checkpatch.pl
@@ -526,6 +526,25 @@ our $InitAttributeData = qr{$InitAttribu
 our $InitAttributeConst = qr{$InitAttributePrefix(?:initconst\b)};
 our $InitAttributeInit = qr{$InitAttributePrefix(?:init\b)};
 our $InitAttribute = qr{$InitAttributeData|$InitAttributeConst|$InitAttributeInit};
+our $ContextAnalysis = qr{
+			__guarded_by\b|
+			__pt_guarded_by\b|
+			__rcu_guarded\b|
+			__must_hold\b|
+			__must_hold_shared\b|
+			__must_not_hold\b|
+			__acquires\b|
+			__acquires_shared\b|
+			__cond_acquires\b|
+			__cond_acquires_shared\b|
+			__releases\b|
+			__releases_shared\b|
+			__cond_releases\b|
+			__no_context_analysis\b|
+			__context_unsafe\b|
+			__acquires_ret\b|
+			__acquires_shared_ret\b
+		}x;
 
 # Notes to $Attribute:
 # We need \b after 'init' otherwise 'initconst' will cause a false positive in a check
@@ -551,6 +570,7 @@ our $Attribute	= qr{
 			__ro_after_init|
 			__kprobes|
 			$InitAttribute|
+			$ContextAnalysis|
 			__aligned\s*\(.*\)|
 			____cacheline_aligned|
 			____cacheline_aligned_in_smp|
_

Patches currently in -mm which might be from vdonnefort@google.com are


