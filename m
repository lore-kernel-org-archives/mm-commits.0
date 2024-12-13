Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07D8C18BC0F
	for <mm-commits@vger.kernel.org>; Fri, 13 Dec 2024 06:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734072019; cv=none; b=FDQwwScLfoa3jTeYl2oQFoIwInS0Bd76AX74SYzSme+Faa4NblYfXFjHUGXBnWO154QWtgj5v6ilee3BDbLJQ1jooE6V6T2M18bISHa6ydiixfw1bjKgoWWrj1nxKwLTND1xeADy30+zR/f5AQJT27zDT29Svnl3K5pfWOdwsQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734072019; c=relaxed/simple;
	bh=YZ4N8NE3ukddsy64hRsAkOmO32T5a/k/Tkl/h+tZx+c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xkd6ek2evfuDBlnGs950m6disp6yyXsH1LMnin1TSZOFhstmeyQN2yU7kQrgnvagl+sIFD6G9k6OZRrFGxcBO07bl1xbjUjvRqrXjoSbJVPAod39JKsmOAPKd8zcl3acUYsUWDJHVJHffeXJa2OUeWSBFiUZ8ZdU+lHubwg7YTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=ZGZZK/7Q; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="ZGZZK/7Q"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-21649a7bcdcso13924765ad.1
        for <mm-commits@vger.kernel.org>; Thu, 12 Dec 2024 22:40:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1734072017; x=1734676817; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EYra4WLBik/qk2CTypUbNS7MwOB8IWprDYcVUfZtL5U=;
        b=ZGZZK/7QD54hNr6wupLEZGzMzNmXFzk0hoA680y/9gdZOjQ+xRfeNyjtoiQuflzzz+
         bU36NHLfmWxoPLtFm9f1zRG4mLdD7nDtAWJWHpDZRy9J4g5Iv3EQ6fagCiXm1Br0OJ2r
         Qfd9AAGj0wV3P0rUhfFXT9x4KGzm/Ewhbf+BE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734072017; x=1734676817;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EYra4WLBik/qk2CTypUbNS7MwOB8IWprDYcVUfZtL5U=;
        b=oy1TFRgtj/vBQFQGrW/iXJ0ryOQIJ4lwgsoIk8PstNr07+jAS96sPlAzuQEPdYqIlj
         9AeZCrb6VVcrgt3FSjbDmIMTB7/uovxGn3xPEjluxzz/tGGsBsaqfh+fr0/VNy2+2uR0
         qHyFyDXM++I8LD5Oa2GEu+cLBiW8tHlH5kSbYzPtsXIzichNL9IUfYOqDDJEVniBKkoE
         7zIvcRtKQzaUPOk8cmSmkACxwrWbAgj3t4E33Au2nEiBTWv3VASN+8k5Rwej5cxRDQja
         NklsFYEbRWO6F/v11GQ/bcAB/glR0dchvqQl6dvBA0ZooPhOYQ2mtIzs8t05cUvpM+Cj
         skMg==
X-Forwarded-Encrypted: i=1; AJvYcCXKS0Himnz14z6elABhcDgedYz9x8PSVVv8jng5zZ4uYzvgVDKH5JfLXSeS5v9ZD70Ub6ET6GZKtLO/@vger.kernel.org
X-Gm-Message-State: AOJu0YxTGh6W5zjYDPPyWrArTPSQslBvXWnAjDQA6psoTtE1n1IJufcS
	czkCqBdskO5AIbpeVxBsctSXQjCuKaDq9wwvXmmMlbRAr6M45ZhVR9uJBTyqtqg0bwDZGsGeugk
	=
X-Gm-Gg: ASbGnctOW5FQK37BxEkw0kttPYD4eGK5zNH37JRSXQHpQc3G+C/bbC4/Uj3vMkATq22
	EqEusQjPcjVMrYl+4qF9VAhIyks6xNWagzkXcBJJqa03gr+zjmFDIPA2DN2w9GX3kKVh17/edEs
	1aAs0f08D0T6j2+kJ+/LFF8//okQnepjK1KtEI/u2GVbn2Z7rJqyWynOIcxxrmjKV47hOL77RgL
	fw3szdAcwfVwZ5ZWj7+hV+JnJ/vr1Ay5+6kFo3Bt9Ttfr59uRDwDJ0Ms44n
X-Google-Smtp-Source: AGHT+IF1/MXSU/dPzvdN4HhvPI/631oOjb7h/AHDY0BSBNjcjW6nmDgxdBYXYnxWN2dlsh9Z9RZCzA==
X-Received: by 2002:a17:902:e748:b0:215:577b:ab77 with SMTP id d9443c01a7336-21892a40509mr21396905ad.39.1734072017384;
        Thu, 12 Dec 2024 22:40:17 -0800 (PST)
Received: from google.com ([2401:fa00:8f:203:2d7e:d20a:98ca:2039])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2166fc21dd6sm57744615ad.123.2024.12.12.22.40.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Dec 2024 22:40:16 -0800 (PST)
Date: Fri, 13 Dec 2024 15:40:12 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: caiqingfu <baicaiaichibaicai@gmail.com>
Cc: caiqingfu <baicaiaichibaicai@gmail.com>, akpm@linux-foundation.org, 
	caiqingfu@ruijie.com.cn, minchan@kernel.org, mm-commits@vger.kernel.org, 
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: Re: [PATCH] zram: panic when use ext4 over zram
Message-ID: <gxxr7y3honggqff4fgmss3v3hcnwplywkhce7al47ji3rzql5c@l3g6c6kpzzwg>
References: <5qmps6mcifydwtnsynxdtipaoerjrnjlpo6gztxfdryn37bvws@fp2xqjmiews5>
 <20241213055630.163185-1-baicaiaichibaicai@gmail.com>
 <ix3p5j34pjke3tf7pmt23vnjsvejcgdlycmz6nnjxtewjn6pzd@wfjkarwokcox>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ix3p5j34pjke3tf7pmt23vnjsvejcgdlycmz6nnjxtewjn6pzd@wfjkarwokcox>

On (24/12/13 15:28), Sergey Senozhatsky wrote:
> The data must not change.  That's the only "must" thing.  zram
> cannot and must not tolerate buggy upper layer that do not respect
> BLK_FEAT_STABLE_WRITES.

The solution (per [1]) is

"we need to teach the buffer cache writeback code to issue writes
through a bounce buffer if the device requires stable writes."

Unless somebody is already working on it (I'm not aware of that),
please feel free to submit a patch, that would be highly appreciated.

[1] https://lore.kernel.org/linux-fsdevel/20241212140437.GD1265540@mit.edu
