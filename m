Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795550463;
	b=UagsonaUGnNzFgTShptIehTDnPnsHLH3ff9iu82za0qoQyndDbQwoqdJXqtQeRnISDPP
	 vksxOh7Jfa+jg1Tx4XXDko0nXrMVLGEu6H06N2g4IetftWJDZTqRxlhCCDphzZ+VoFRql
	 hITfvGP8ZzoHnRt9oXWh19Br1UdyijopC1FmU19SIzSBCied2UxffLJl0hUCenJLKaYtl
	 9mTsX6krURUjgX73dUuKMPBKTRpr5Ec7+7+aXr61sBn3nPcku+xB9diUg3TQs7Vb87V1I
	 b/kDUAZx6UWNhEWvxCM/Fn+1zCIkN+6AuxZW0ouxcqVBicVk7X7YGupKh650X4t917w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795550463;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=lsdYSI7hGgRJIg6qojJSoqbITWU0kjCpXKTL++GqWNU=;
	b=GspYSiFl0P6u9b7j5jrFxd3JSAED4ET27VE71jAxFsGHIAYLjkmvRYmLyTo8YnlDYTX8
	 nG4vOK0VQhpFQlfFAPkoL4q9bB6gFmt4psHPekY97Co9b3DY/vadw/GtOZ4HXd8VYu1jb
	 YYBuVF4EPcp0uNFzEb8/A0f+7a7quf/kB4+6E5lndtQjTK2s3hlCvNM2TzJNavfaM1211
	 k6Y+brtHQWu+DCX1BAk6BrR/ulK4zy25jBG2aPuca2GqJGuW4fL/S2oeKEJoPKa201At5
	 /WFgcOJqF8XsaJdMamQ4hHgshsUrPuQ+KYePh2V3IbHbgeUjfanCS/Xtx38vX/KLg1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=gmq5DqoW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95038606A31E
	for <mm-commits@vger.kernel.org>; Tue, 24 Nov 2026 20:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=gmq5DqoW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 061401F000C0;
	Tue, 24 Nov 2026 20:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795550463;
	bh=lsdYSI7hGgRJIg6qojJSoqbITWU0kjCpXKTL++GqWNU=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=gmq5DqoWaWn+7mWlGZd8huRfLTdjViZEJEn6ce8anfF/P7x1uv/aqQ0S/wFHHr9nv
	 933JMwOU2DkhXlyVVkWNsP3A9LOJH7dVcVbYB8slZx2tbfNyRqPJHxDcHonJ5eSqR8
	 6DeXOOkllECWjo2eopE/JuHE+ufqChtDYY6M+xaI=
Date: Tue, 24 Nov 2026 12:01:02 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,
	surenb@google.com,mhocko@suse.com,hannes@cmpxchg.org,
	brendan.jackman@linux.dev,aleszlucero@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261112-page-reporting-doc-v1-1-593af69f3801@gmail.com>
References: <20261112-page-reporting-doc-v1-1-593af69f3801@gmail.com>
Subject: [merged mm/page_alloc.git: page_alloc/for-next] mm-page_reporting-document-order-parameter-in-page_reporting_notify_free.patch removed from -mm tree
Message-Id: <20261124200103.061401F000C0@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/page_reporting: document @order parameter in page_reporting_notify_free()
has been removed from the -mm tree.  Its filename was
     mm-page_reporting-document-order-parameter-in-page_reporting_notify_free.patch

This patch was dropped because it was merged into mm/page_alloc.git: page_alloc/for-next

------------------------------------------------------
From: Oscar Alejandro Sánchez Lucero <aleszlucero@gmail.com>
Subject: mm/page_reporting: document @order parameter in page_reporting_notify_free()
Date: Thu, 12 Nov 2026 10:18:19 -0600

Add missing kernel-doc description for @order to fix a kernel-doc warning.

Link: https://patch.msgid.link/20261112-page-reporting-doc-v1-1-593af69f3801@gmail.com
Signed-off-by: Oscar Alejandro Sánchez Lucero <aleszlucero@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Zi Yan <ziy@nvidia.com>

 mm/page_reporting.h |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/page_reporting.h~mm-page_reporting-document-order-parameter-in-page_reporting_notify_free
+++ a/mm/page_reporting.h
@@ -23,6 +23,7 @@ static inline bool page_reported(struct
 
 /**
  * page_reporting_notify_free - Free page notification to start page processing
+ * @order: allocation order of the freed pages
  *
  * This function is meant to act as a screener for __page_reporting_notify
  * which will determine if a give zone has crossed over the high-water mark
_

Patches currently in -mm which might be from aleszlucero@gmail.com are


