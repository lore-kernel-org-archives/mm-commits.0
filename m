Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795455220;
	b=5Xb8cQn/JJbcesz/L0vmepy90ZTTMbfexzRhA3+iQyaE4P00PYwZvEtx1MEg+2f3Z7m2
	 FOPVgitHt/X7KNbL+KYAgE7IhC1AAL41aFbjT2HhNuwJ2uNUjbRHZSrtHcdDukbfhLEoB
	 /CzInEK3sBV1Q0xk4jxRRt5LSVahk5qfNT7osEBNVse8oo0Q4fkEnsHZvOy+hrA9cheYs
	 LEhV9LoEPD88hHr9jOMiwp9ufe+TWfT+UYGNCOXbvPx4FMiMBm2o2PrEQdqpql57vmIUR
	 TV9tof4ac51oFXRjV74ZCCjCcm7+uPFUVhU1u6rL+i+kY//ekbxSziHyE1V1bJ8Pi/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795455220;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:From:
	 Content-Language:To:Cc:Subject:Autocrypt:Content-Type:
	 Content-Transfer-Encoding;
	bh=5HtEpmoQ6G7capBKDM7qPLa87D7mxUScfweCh+MCKW8=;
	b=sPghT2FiVFBWZynEBqwIp3/sMKjBpZxeO7eoLTsRDuhTvz4y43+YECGGJTdDWXEeNIY5
	 d+kS+ezrnpvd7LrXkyJfQdb0I0XjE8TOc6e+IGuEdxQpNQX0udXzo0MJW3rWFTPb//zqZ
	 bXfRNB4QAqFte8nlvEZWOXi36rWkV/eesBVvuZfBuUpGlFnjyFgaTbZgWcHvRzyNSqbAy
	 C0K8xdWtryog4FklC8t2ReqGkioC96f5LS+S1fMz3fPDbNEw5eL4vc+1W1H7zlFLYyqVH
	 ZW4lhk27yhM1VPTh4MkNrdXIHCe8F/c4Azj6nLa1BL096Wxx/mBttA+0hEnEwm7vqrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WZ72lU4g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B810606A32D
	for <mm-commits@vger.kernel.org>; Mon, 23 Nov 2026 17:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WZ72lU4g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4296E1F000C0;
	Mon, 23 Nov 2026 17:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795455220;
	bh=5HtEpmoQ6G7capBKDM7qPLa87D7mxUScfweCh+MCKW8=;
	h=Date:From:To:Cc:Subject;
	b=WZ72lU4g29dW+JYDunv4jiSppBBcQhdbzTprbtcaBf6WP+mciZ4HLAPhfLtBzvNh8
	 bytvtUNQKXgfb+DQIcOmaST1lI+n/RXKqHTHhrIBVw1XBrQpm8NXTFVTf/T2EgHNUn
	 8sIYVce4+Tiqek0SZT5had8TO3PlUAddUXhp8FrAAQgZJeogfcwnwq1TdkIrm+oavg
	 AdVSWI1N8oXYuA/dZcjiuhcelJcln7QfHSpPBo9AORPXwlikcezhfstpr077DYTMKI
	 GKQ/S5v6JVkAb6ddm0IUBiQeN4EFq8YJxnBEXxfZYPlYfEnVE9Ra/ElldDbhdXlG1u
	 9Yxjg4aGWV6Ig==
Message-ID: <a2b9c99e-b5d3-428a-9b9f-0761b352dbfd@kernel.org>
Date: Mon, 23 Nov 2026 18:33:36 +0100
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
To: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>
Cc: "mm-commits@vger.kernel.org" <mm-commits@vger.kernel.org>
Subject: mm-next: manual merge of the akpm/mm-unstable branch
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

today's mm-next merge of the akpm/mm-unstable branch tree got a conflict in:

  include/linux/alloc_tag.h

between the commit:

  dbbc5a3d50f9 mm: vmscan: tell direct reclaim the allocation is ALLOC_NOFRAGMENT

from the page_alloc/page_alloc/for-next branch and the commit:

  2cc623f19566 mm/vmscan: move vmscan tracepoints to a local header

from the akpm/mm-unstable branch.

The conflict doesn't make any sense, because we're really touching something very unrelated.
It's likely a merge config problem on my end.

I resolved the conflicts manually for now and shall investigate:

diff --git a/mm/vmscan.c b/mm/vmscan.c
index e94d58aa2626..1b3acbbfed15 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -72,8 +72,7 @@
#include "swap.h"

#define CREATE_TRACE_POINTS
-<<<<<<< HEAD
-#include <trace/events/vmscan.h>
+#include "trace_vmscan.h"

 struct scan_control {
      /* How many pages shrink_list() should reclaim */
@@ -185,9 +184,6 @@ struct scan_control {
      /* for recording the reclaimed slab by now */
      struct reclaim_state reclaim_state;
 };
-=======
-#include "trace_vmscan.h"
->>>>>>> akpm/mm-unstable

 #ifdef ARCH_HAS_PREFETCHW
 static inline void prefetchw_prev_lru_folio(struct folio *folio,

-- 
Cheers,

David


