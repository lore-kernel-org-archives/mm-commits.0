Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F3011D2794
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 09:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725270301; cv=none; b=Qe8t+P5mgjY5nwWicaPm1DB+aw8kvokYY+4SckMi7sMUEpXYMZbhlM5ykin4PsGCcEm++b1TWxefdZGZvHFUFi8LgkqDRX87F9jfShIA1yjLNMdwviDOlFDr/tWxmpIDYnGnVvsqqaMlzeT0dd1cX4sdppegHvptzdGRTQ3kje4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725270301; c=relaxed/simple;
	bh=7YYg8VEFEQtf9A2mWWjR5atTkwbrbBewDKUGPlCKvTE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VP0nLEqK7lcnGvxHsGVDYBVttRRNVpkz/eiKWL+3CFTUILyBPNQCbH8EJLTEsN0HxZEmx66yY4SPw1eoavbyt9MJBmKQdxeCxZ9+Bz3+bH5an23at6JPjNIU6zaI2SP6EW/A3I5mANnRbtyeI+bVlWpGfhCbni8S+zqOaoEXWPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=fs0/ZxEJ; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="fs0/ZxEJ"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5343d2af735so3873120e87.1
        for <mm-commits@vger.kernel.org>; Mon, 02 Sep 2024 02:44:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1725270297; x=1725875097; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=7YYg8VEFEQtf9A2mWWjR5atTkwbrbBewDKUGPlCKvTE=;
        b=fs0/ZxEJp2Lm1+rvdXYtyVH7u5MjEAPG2LpxxzXAaSMQy6QjxbG/2tCWa1wqtgOoRK
         qC5koN7FzYcz2yCv3MCB7n9+YdzGOeEDubcSWP7AprYQ0x8DqEDBmAOCVDwIvzn+6Qmn
         UiqzxzG+Ee1jmTHRLKKyNYTCtKa4GwDGnZlro=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725270297; x=1725875097;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7YYg8VEFEQtf9A2mWWjR5atTkwbrbBewDKUGPlCKvTE=;
        b=Sm4X3x0e0NgDqNJYIKtHx0OKmD4xHrjTRx1NMqeuYkicN9Yl91dQUCqbspzyZwUFND
         XMJ3lpiLTPXDxEgdo7W5dpwjWZlnCfKOFhjEZq7uZknTIwKLnh1vIZnOixZRc7ZSPZZh
         W+FBnlc0btQq1anY6MHQ7DW3zApUAHEAqzTCHVpGWmV15tChh3Kvwwmx0wiBH1DhWo0i
         2yD5qGfdsTeByx8z5VmdnXIOBSfwifMDnhRELuQbHEuzfQKTc8KUORhuzWBqJb5xSEHL
         4OJnuvI56ZtJZ5sdnyBr+qWvvg3WJFrGgVpXruBqKVkkaf38pXENl61jjjOnne55mR0H
         Kx1Q==
X-Gm-Message-State: AOJu0YxuW61v6ihEueCZD2eSPDCTrfjmcZy/lJRQ0V54pzBwHMr4ot0p
	dPbhmsRaylyz44CO4IUISmus997vPQ5v6bGtb4vK/VAWBhkK0cpwBY2lBAkaGhg7DWK6VgeLlF/
	LqBohScvF0ytNdcMgMPxnzelOehctfJFugKe39J/saq0qkBNm
X-Google-Smtp-Source: AGHT+IG6ugVnz9FVVGsqRb1xuBW+0eiPZLwqPzsbJSiYVByvEFSVI9tup4E87bnSzK3fC6hJSnOF7EUK2Qn19T/vm1E=
X-Received: by 2002:a05:6512:39d4:b0:530:abec:9a23 with SMTP id
 2adb3069b0e04-53546b25841mr6622961e87.17.1725270297334; Mon, 02 Sep 2024
 02:44:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240902033004.5128EC4CEC2@smtp.kernel.org>
In-Reply-To: <20240902033004.5128EC4CEC2@smtp.kernel.org>
From: Takaya Saeki <takayas@chromium.org>
Date: Mon, 2 Sep 2024 18:44:45 +0900
Message-ID: <CAH9xa6eWt4nDE-1a4ZHsz9Z2e5muAYwEZ1+dJRSeKxzowhkYfA@mail.gmail.com>
Subject: Re: [merged mm-stable] filemap-add-trace-events-for-get_pages-map_pages-and-fault.patch
 removed from -mm tree
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, willy@infradead.org, uekawa@chromium.org, 
	rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com
Content-Type: text/plain; charset="UTF-8"

Hello Andrew, there is a newer v4 version for this patch.
https://lore.kernel.org/lkml/20240816211029.903842-1-takayas@chromium.org/T/
Do you mind letting me know how to correct the patch being merged to
the latest version?
