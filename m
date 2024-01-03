Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 862DC468C
	for <mm-commits@vger.kernel.org>; Wed,  3 Jan 2024 02:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=I-love.SAKURA.ne.jp
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=I-love.SAKURA.ne.jp
Received: from fsav415.sakura.ne.jp (fsav415.sakura.ne.jp [133.242.250.114])
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 4032kCqZ069871;
	Wed, 3 Jan 2024 11:46:12 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav415.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav415.sakura.ne.jp);
 Wed, 03 Jan 2024 11:46:12 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav415.sakura.ne.jp)
Received: from [192.168.1.6] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
	(authenticated bits=0)
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 4032kBGI069867
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
	Wed, 3 Jan 2024 11:46:11 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <c3cdc9b3-a06f-4be7-af3b-44abb8d72c7d@I-love.SAKURA.ne.jp>
Date: Wed, 3 Jan 2024 11:46:11 +0900
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: +
 mm-shrinker-use-kvzalloc_node-from-memcg_expand_one_shrinker_map.patch added
 to mm-hotfixes-unstable branch
Content-Language: en-US
To: Qi Zheng <zhengqi.arch@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org,
        syzbot+1e0ed05798af62917464@syzkaller.appspotmail.com,
        songmuchun@bytedance.com
References: <20240102175847.AA94EC433C8@smtp.kernel.org>
 <35fc708f-c27c-4b37-99c2-f6c0db8db1d5@bytedance.com>
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <35fc708f-c27c-4b37-99c2-f6c0db8db1d5@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2024/01/03 11:33, Qi Zheng wrote:
>> Link: https://lkml.kernel.org/r/b1a78c6a-b3fa-46ed-810a-ce546e726d44@I-love.SAKURA.ne.jp
> 
> Thanks for fixing this!
> 
> Reviewed-by: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> BTW, this link above seems to be inaccessible:
> 
> ```
> Message-ID <b1a78c6a-b3fa-46ed-810a-ce546e726d44@I-love.SAKURA.ne.jp>
> not found
> 
> Perhaps try an external site:
> ```
> 
> And I did not find this patch in LKML.

Hmm. It seems that I should not remove linux-kernel@vger.kernel.org when posting to linux-mm@kvack.org
because lkml.kernel.org does not archive linux-mm@kvack.org and syzbot can not find this patch.

Andrew, please take v2 which corrected function name.

> 
>> Fixes: 307bececcd12 ("mm: shrinker: add a secondary array for shrinker_info::{map, nr_deferred}")
>> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
>> Reported-by: syzbot <syzbot+1e0ed05798af62917464@syzkaller.appspotmail.com>
>> Closes: https://syzkaller.appspot.com/bug?extid=1e0ed05798af62917464
>> Cc: Qi Zheng <zhengqi.arch@bytedance.com>
>> Cc: Muchun Song <songmuchun@bytedance.com>
>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

