Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E2B91B4140
	for <mm-commits@vger.kernel.org>; Wed, 29 Jan 2025 11:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738150328; cv=none; b=oAqTtcBdPMn0iJuJkLReFis9m9clBWGnZxyJagltNDbvxbfSb4AcDSaICwVGLOOUE6XJsQqgNAOY3iGWjpRqn6bb/IZ26ATY07dumPCAR3AHoi9/8fuTlnCGQv4LUDrOZhMvI4cqiS8URe/lZUqbXMIoYfwr6qDAnutwKxeC9js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738150328; c=relaxed/simple;
	bh=ec+PkL1HiZlJFikdV5YMVhNyV41Bfg4BY1lo69uHnTI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E43Oy0aNnUIQ+SFBDD0lmjZ+gyWs6p9ev09YW/JzvHSRRcvzAJkEWm2sRAcLyayyiJ//Soe0o5wVQSrSlcEayZStaSkK8US5zedtCq6hHnLabCNxE+RwWF3K4d7CEGE39443qaWsh4pJhGjMQwK1cj8LftXzLyx2NINPeIlnLfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=VCrp/9QG; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="VCrp/9QG"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-2eec9b3a1bbso9311896a91.3
        for <mm-commits@vger.kernel.org>; Wed, 29 Jan 2025 03:32:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1738150325; x=1738755125; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xtnss+Gb5XikH7vvXdfEhwKL9wwVbD0ioOTKi33yexc=;
        b=VCrp/9QGtHIDeI83aeszii2IurjYZe/aiv3k8460wRQa2ingx4G22e+Wh5Wak9jyta
         5uO9HsMlzonxSLytJkI5fcVXCWu+24bNH9YW46v8Ua/gEFtiwTG/kT51SfID5/J+jdbT
         ODpCUm+IcohGn+7+NenaihwrGJ3YutO6DQccQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738150325; x=1738755125;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xtnss+Gb5XikH7vvXdfEhwKL9wwVbD0ioOTKi33yexc=;
        b=D8y0UjbX2R7JbplXNzCRZ6prnMXuZzV3pMosDjpMtiXSfeFTM9GyGLRIi4trVu9R29
         9j2AiRuFPsjA9OYnJY7WGmjLwXuYOws9EGPXpsWWeRwenoboubb6S5GxNi/3Cwadi/09
         0/fBw6BaAInbPL0bWFFdH83xy0tOrFQh2EGi6WJT4snV9ghPWZ8Rr1s2l1yLpF2M9NZZ
         A7z3DYa1+4nS0HTxc6dCuMPZ4sw50QCcAIP5ZQ4lyTzKKciqcXHg6yhyjiRKn+t/Wtmh
         iHzuI/y53gfDcGzfTjOslGijmi/d4MN/oKam8dPzJXr0Hu5P79YJ6pAVEimpues61t9U
         moBA==
X-Gm-Message-State: AOJu0YxyED5NchiU+CzTzkTs1IIiTR7+wUU3u0X+yOJVaFAZjav7HjEf
	mhSdPhzMYdZmvy8SJ6GizgKT9RZWAuYyqZ3L4tPqCoBjZuvz+A9P/8HTyF23Iw==
X-Gm-Gg: ASbGncuWqubti9ifbbjsAw2o9i1OktqM99WofZpl5BQ1XEfWWAsSidL9OxfbRk57P71
	E4EZi6klvFL8VUOr+HlHa1pdaG0aGTcoZUAWAGpDp0mcfMAsS4PLPwwaydO/J/GFRdbgOxnrRPy
	q/QACy7y7BZoYu088hQdGi1p8Gsjl6VT2TZX9fJE7+u2ThMYo42qYQnKfdEBrB/lrEE259BMmI/
	yHZPG6laqZFG8PdiZAivld8h5KWxD+GWP+xbkMnwNPwB6h14JEhJkaR9kCw1T4NWG9Q22cIKD23
	cLYuKJSUf40I6ckBLHs=
X-Google-Smtp-Source: AGHT+IEoH4L62Z3tLPXsj1rmsaqPiyQdfC7h227o4qHkZfLB3ElVOl5BNu45WfHkXjD/gV1qG8qXzw==
X-Received: by 2002:a17:90b:4d06:b0:2ee:ab29:1a57 with SMTP id 98e67ed59e1d1-2f83abb3553mr4205184a91.2.1738150325505;
        Wed, 29 Jan 2025 03:32:05 -0800 (PST)
Received: from google.com ([2401:fa00:8f:203:d794:9e7a:5186:857e])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f83bc98144sm1397410a91.2.2025.01.29.03.32.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jan 2025 03:32:05 -0800 (PST)
Date: Wed, 29 Jan 2025 20:31:59 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, minchan@kernel.org, 
	senozhatsky@chromium.org, Uros Bizjak <ubizjak@gmail.com>
Subject: Re: + zram-switch-to-non-atomic-entry-locking.patch added to
 mm-unstable branch
Message-ID: <eqdrqsj5tgvbq5ocahgl3e6wog53l4fi5qjhejhklbpm5z64yb@oqrqm6vvf7vi>
References: <20250127205809.A05DDC4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250127205809.A05DDC4CED2@smtp.kernel.org>

Cc-ing Uros,

On (25/01/27 12:58), Andrew Morton wrote:
[..]
> -static int zram_slot_trylock(struct zram *zram, u32 index)
> +static int zram_slot_write_trylock(struct zram *zram, u32 index)
>  {
> -	return spin_trylock(&zram->table[index].lock);
> +	int old;
> +
> +	old = atomic_cmpxchg(&zram->table[index].lock, ZRAM_ENTRY_UNLOCKED,
> +			     ZRAM_ENTRY_WRLOCKED);
> +	return old == ZRAM_ENTRY_UNLOCKED;
>  }
>  
> -static void zram_slot_lock(struct zram *zram, u32 index)
> +static void zram_slot_write_lock(struct zram *zram, u32 index)
>  {
> -	spin_lock(&zram->table[index].lock);
> +	atomic_t *lock = &zram->table[index].lock;
> +	int old;
> +
> +	while (1) {
> +		old = atomic_cmpxchg(lock, ZRAM_ENTRY_UNLOCKED,
> +				     ZRAM_ENTRY_WRLOCKED);
> +		if (old == ZRAM_ENTRY_UNLOCKED)
> +			return;
> +
> +		cond_resched();
> +	}
>  }
>  
> -static void zram_slot_unlock(struct zram *zram, u32 index)
> +static void zram_slot_write_unlock(struct zram *zram, u32 index)
>  {
> -	spin_unlock(&zram->table[index].lock);
> +	atomic_set(&zram->table[index].lock, ZRAM_ENTRY_UNLOCKED);
> +}
> +
> +static void zram_slot_read_lock(struct zram *zram, u32 index)
> +{
> +	atomic_t *lock = &zram->table[index].lock;
> +	int old;
> +
> +	while (1) {
> +		old = atomic_read(lock);
> +		if (old == ZRAM_ENTRY_WRLOCKED) {
> +			cond_resched();
> +			continue;
> +		}
> +
> +		if (atomic_cmpxchg(lock, old, old + 1) == old)
> +			return;
> +
> +		cond_resched();
> +	}
> +}
> +
> +static void zram_slot_read_unlock(struct zram *zram, u32 index)
> +{
> +	atomic_dec(&zram->table[index].lock);
>  }

Hello Andrew,

I think I want to make these look as close to zsmalloc implementation
as possible.

A simple patch below.  No functional changes.  (also renamed
zram_slot_write_trylock() to zram_slot_try_write_lock() which is a
more common naming convention for functions of that sort.)

Would you prefer a complete re-spin of the series, with these changes
squashed, or a "fixup" patch?

---
 drivers/block/zram/zram_drv.c | 41 +++++++++++++++--------------------
 1 file changed, 17 insertions(+), 24 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index d73e8374e9cc..9622fcad2115 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -59,28 +59,26 @@ static void zram_free_page(struct zram *zram, size_t index);
 static int zram_read_from_zspool(struct zram *zram, struct page *page,
 				 u32 index);
 
-static int zram_slot_write_trylock(struct zram *zram, u32 index)
+static bool zram_slot_try_write_lock(struct zram *zram, u32 index)
 {
-	int old;
+	atomic_t *lock = &zram->table[index].lock;
+	int old = ZRAM_ENTRY_UNLOCKED;
 
-	old = atomic_cmpxchg(&zram->table[index].lock, ZRAM_ENTRY_UNLOCKED,
-			     ZRAM_ENTRY_WRLOCKED);
-	return old == ZRAM_ENTRY_UNLOCKED;
+	return atomic_try_cmpxchg(lock, &old, ZRAM_ENTRY_WRLOCKED);
 }
 
 static void zram_slot_write_lock(struct zram *zram, u32 index)
 {
 	atomic_t *lock = &zram->table[index].lock;
-	int old;
-
-	while (1) {
-		old = atomic_cmpxchg(lock, ZRAM_ENTRY_UNLOCKED,
-				     ZRAM_ENTRY_WRLOCKED);
-		if (old == ZRAM_ENTRY_UNLOCKED)
-			return;
+	int old = atomic_read(lock);
 
-		cond_resched();
-	}
+	do {
+		if (old != ZRAM_ENTRY_UNLOCKED) {
+			cond_resched();
+			old = atomic_read(lock);
+			continue;
+		}
+	} while (!atomic_try_cmpxchg(lock, &old, ZRAM_ENTRY_WRLOCKED));
 }
 
 static void zram_slot_write_unlock(struct zram *zram, u32 index)
@@ -91,20 +89,15 @@ static void zram_slot_write_unlock(struct zram *zram, u32 index)
 static void zram_slot_read_lock(struct zram *zram, u32 index)
 {
 	atomic_t *lock = &zram->table[index].lock;
-	int old;
+	int old = atomic_read(lock);
 
-	while (1) {
-		old = atomic_read(lock);
+	do {
 		if (old == ZRAM_ENTRY_WRLOCKED) {
 			cond_resched();
+			old = atomic_read(lock);
 			continue;
 		}
-
-		if (atomic_cmpxchg(lock, old, old + 1) == old)
-			return;
-
-		cond_resched();
-	}
+	} while (!atomic_try_cmpxchg(lock, &old, old + 1));
 }
 
 static void zram_slot_read_unlock(struct zram *zram, u32 index)
@@ -2315,7 +2308,7 @@ static void zram_slot_free_notify(struct block_device *bdev,
 	zram = bdev->bd_disk->private_data;
 
 	atomic64_inc(&zram->stats.notify_free);
-	if (!zram_slot_write_trylock(zram, index)) {
+	if (!zram_slot_try_write_lock(zram, index)) {
 		atomic64_inc(&zram->stats.miss_free);
 		return;
 	}
-- 
2.48.1.262.g85cc9f2d1e-goog

