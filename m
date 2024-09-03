Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BB291AD262
	for <mm-commits@vger.kernel.org>; Tue,  3 Sep 2024 10:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725358868; cv=none; b=ZdNImnJJuHpxyx22hIttQ6nQP4oJ0fmsAxSMiWsQvo6ncUXe2g8PCB+9yiSYMfxq6kajR6vlHAzN52wqgqgJd2m1Bzhx8LQqgOSV6kYy3/xmvzjAGnysttWuF3o9SOsvpo81LGstGLpfTEOxq9B26HCiXc80X2aa3UpzFKt8Wug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725358868; c=relaxed/simple;
	bh=90q+s0sqBta5N9yYCsdrpxFLs68aqpy0QWdEo3/i7KU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IeWGDIx4H7J5S8BIvF/bywcWDluK/63ur6X8jIZlHh+GhaOMTGvoZq3Xc81Q2b/0PNpuHE5gWulqt+A9OnLiTJY3BYodSKpi7VGxL0cscgDfzX4xVpBOuohQ2EOTjiXfuhb+36i+yJDbxRrCrVdzHN3FxDZ/oyoMgAO6Jhu6mF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=fpDCT6Xi; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="fpDCT6Xi"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-7141d7b270dso3988339b3a.2
        for <mm-commits@vger.kernel.org>; Tue, 03 Sep 2024 03:21:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1725358865; x=1725963665; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fVqsz3SmhEEppmDAu57Eic/0gAwgUnSCIdY0e9Rjewo=;
        b=fpDCT6Xi5SZZvOLcp3xK9UpVR/u31POCzWeUoAoiw/FDT8XZgTi5fcrepsbS8xdzyO
         SPVOLA3YWIlNjwbOVtF5YeJwW6shKxhzF1yOYZG0B4G2zqsj4Tgwy12KOwlWVC/dyGVS
         azUdqZEQv43a3Bs26/t7tXiWaZpgygwZ85w5U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725358865; x=1725963665;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fVqsz3SmhEEppmDAu57Eic/0gAwgUnSCIdY0e9Rjewo=;
        b=CM2LNM0JkrK6Z5WSjVtrX8qT6usIL7HkHd4MNO/72EgjesK91ELgR0Ef+Pqz5JjDPo
         ZbEhw2guMm8FPWRv1kfMOScfFK00T4xE7UoJXm7VH+OBX3oB1o8BOVRfMJgJoW5gHs7B
         ql/0wyPF1qaeCogQAopGiV7ft83t1mQdREIi23FZvtQMuByyDipWgNENAl4fTHDwCAGN
         YCo0qTDsw+ajzETphjEoZzL2G10p3AWjQ1d8ppKor+SnLeMCLjH/TMqZGtWQFfTweJ3+
         ywqqnaOfNMJxW+WVibIjgdHG0xSmUvBrpZuDf+qsvZVBVN2gtKcnH0uwukM2/hP4lRFN
         murw==
X-Forwarded-Encrypted: i=1; AJvYcCV1yYFE9axmQ7hotpvaBm2b4WdVpEk1WK3XNpT9IwI62F+3++pHFEwyzXL2XsG7iJCsqB0MmxLYqMii@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+dn0CQREv2GEcUbnOwyu+9LN8ntarM7OxA9nojNjgZmNn18M5
	FN4XKpk6BrIm4pAdTGJLd8KW7vxPPpytRZ41X61bS92HDD49WMgtvmbxk3SVtuk2yQ8oXcBq+w=
	=
X-Google-Smtp-Source: AGHT+IFhhz5ECGbJsz+m7VCW1TA++nfbQcROFMuIA6WKQidJVbXg4fP3LNhjndcxAj6JmGHXpzhOFg==
X-Received: by 2002:a05:6a20:d487:b0:1c4:98f8:9ccb with SMTP id adf61e73a8af0-1ced62de8famr7315589637.34.1725358865533;
        Tue, 03 Sep 2024 03:21:05 -0700 (PDT)
Received: from localhost (21.160.199.104.bc.googleusercontent.com. [104.199.160.21])
        by smtp.gmail.com with UTF8SMTPSA id d2e1a72fcca58-715e56d8851sm8461356b3a.145.2024.09.03.03.21.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Sep 2024 03:21:05 -0700 (PDT)
From: Takaya Saeki <takayas@chromium.org>
To: akpm@linux-foundation.org
Cc: mathieu.desnoyers@efficios.com,
	mhiramat@kernel.org,
	mm-commits@vger.kernel.org,
	rostedt@goodmis.org,
	takayas@chromium.org,
	uekawa@chromium.org,
	willy@infradead.org
Subject: [PATCH] filemap: fix the last_index of mm_filemap_get_pages
Date: Tue,  3 Sep 2024 10:21:00 +0000
Message-ID: <20240903102100.70405-1-takayas@chromium.org>
X-Mailer: git-send-email 2.46.0.469.g59c65b2a67-goog
In-Reply-To: <20240902123526.37112a46daff0fd59061a955@linux-foundation.org>
References: <20240902123526.37112a46daff0fd59061a955@linux-foundation.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In commit b6273b55d885 ("filemap: add trace events for get_pages,
map_pages, and fault"), mm_filemap_get_pages was added to trace page
cache access. However, it tracks an extra page beyond the end of the
accessed range. This patch fixes it by replacing last_index with
last_index - 1.

Fixes: b6273b55d885 ("filemap: add trace events for get_pages, map_pages, and fault")
Signed-off-by: Takaya Saeki <takayas@chromium.org>
---
 mm/filemap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index fcfec2a78a30..d725d84b1947 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2548,7 +2548,7 @@ static int filemap_get_pages(struct kiocb *iocb, size_t count,
 			goto err;
 	}
 
-	trace_mm_filemap_get_pages(mapping, index, last_index);
+	trace_mm_filemap_get_pages(mapping, index, last_index - 1);
 	return 0;
 err:
 	if (err < 0)
-- 
2.46.0.469.g59c65b2a67-goog

