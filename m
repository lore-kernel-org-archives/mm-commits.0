Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5D10C41535
	for <mm-commits@archiver.kernel.org>; Wed,  6 Apr 2022 01:56:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1454285AbiDFB53 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 5 Apr 2022 21:57:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1448482AbiDEPsU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 5 Apr 2022 11:48:20 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2055.outbound.protection.outlook.com [40.107.236.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3D7C1A847E
        for <mm-commits@vger.kernel.org>; Tue,  5 Apr 2022 07:27:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PG861snloILkfa8MOSFbMhQbGq1Ti4KyFRDQQZ/0aRuRUEYlnGW1q8AsJuh5OkTBNUXH5vYUtdXzXuWKNeFHWr7YFZ/jon8vXlrAG1+WaqZGoqq0pp6+kR4WQH+PVAboAfw79w7zbYdBUUGRPuARbHlm0w1zEdizak4shuXMIzV6DW2mu5ACQvas33EfPqeXqMzYJlCex3kfUYNDBrP9eW6P34Wr3nk69YuahwHE+WQrSQMTNg0eoIfaxM28iE6WeobvTncMMR9Xx5XcSxXUh9sjYKrJdddIxwkh51C2jq/x+SR9ijsdwx4YZfxFf8UHBCBpsVDsqT2vxrzac0gPoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gBQFGoZfOvplK9sVbegoVSH3/q71f01agByJlW0rOuA=;
 b=ibA0p6wXr6OLxdTjQ0qQKtnWS96v3yTPM2CfjSP1I0Af024FZyyi1FhmsilSb7DVFKmPBPGkTFW+KoyV9Io05KXeIjgQDCY5AFaXyUfKhQ03v6JJMPARBF+iaMZmBdodfUoKSWkwxNIHzOoz6iCTp80D1DqQluQOwvYRpal8FzhVgzTk/W6Jmx8+Td+22elC0j0F84vHtTCST3SEw5TaCNHl1T9xSLbb5erQR5nTend+PosOyPRpv6QctJ1A1Nz6dDG9VKQ/le1Q9v3waJTrKjd9fMwcCJhhG+t0ROJc0IHAF4gVMFXljBDvddLCl4peFYUp9gGO6t9jpxRrmG3irA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gBQFGoZfOvplK9sVbegoVSH3/q71f01agByJlW0rOuA=;
 b=LOMvwJs+LmEOSZoMJQ+bYHawYNI655M0kqszgbVkXKE4zleAJqKP6y8q/z5OO0jvrUCrNQx91s29p++2RAfBSLY207PTIauCsj7Wv8WW1VExqzoZ+0RxzHaRL6rlT/GXelvjdDXUZ0CRdUvfu2Q0hTIr6km/HzXYWiM7M+tAFXwwmqAcfgL0pkbbBx/bEvyBnOqC8HIarXmnPWMfjaULG8v2eH6pyCdn1mlqMBncBuVwn6KGlSE4GS6DJvMd54+PEBakeRmG8zRJLMWdpMhJvbcAkezRm5+z9Ke4kLi6y3XRUex8J+N8/ZG2rvVU0/6t9quSsnlbNdWna1PJYjsIiw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB3823.namprd12.prod.outlook.com (2603:10b6:208:168::26)
 by MW2PR12MB2570.namprd12.prod.outlook.com (2603:10b6:907:a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Tue, 5 Apr
 2022 14:27:55 +0000
Received: from MN2PR12MB3823.namprd12.prod.outlook.com
 ([fe80::69f1:dff6:826b:7d9c]) by MN2PR12MB3823.namprd12.prod.outlook.com
 ([fe80::69f1:dff6:826b:7d9c%5]) with mapi id 15.20.5123.031; Tue, 5 Apr 2022
 14:27:55 +0000
From:   Zi Yan <ziy@nvidia.com>
To:     David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Vlastimil Babka <vbabka@suse.cz>, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, rppt@kernel.org,
        rostedt@goodmis.org, osalvador@suse.de, mgorman@techsingularity.net
Subject: Re: + mm-wrap-__find_buddy_pfn-with-a-necessary-buddy-page-validation.patch added to -mm tree
Date:   Tue, 05 Apr 2022 10:27:53 -0400
X-Mailer: MailMate (1.14r5865)
Message-ID: <7236E7CA-B5F1-4C04-AB85-E86FA3E9A54B@nvidia.com>
In-Reply-To: <44c74067-7acc-906a-798a-5ca95f1d1e14@redhat.com>
References: <20220404215048.01A9AC2BBE4@smtp.kernel.org>
 <a4256d36-6f6d-82d7-38a3-1af6f9b2457d@redhat.com>
 <b5d3b61a-02bc-0b46-95dc-bd99ec3d759a@suse.cz>
 <604fd8fb-50df-dafe-14bd-640aa991d4cf@redhat.com>
 <44c74067-7acc-906a-798a-5ca95f1d1e14@redhat.com>
Content-Type: multipart/signed;
 boundary="=_MailMate_F5DDAABF-3DA2-4D80-8E76-4801C2D44134_=";
 micalg=pgp-sha512; protocol="application/pgp-signature"
X-ClientProxiedBy: BL1PR13CA0427.namprd13.prod.outlook.com
 (2603:10b6:208:2c3::12) To MN2PR12MB3823.namprd12.prod.outlook.com
 (2603:10b6:208:168::26)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 42796026-06be-4779-fa94-08da17107954
X-MS-TrafficTypeDiagnostic: MW2PR12MB2570:EE_
X-Microsoft-Antispam-PRVS: <MW2PR12MB25709BC66B6DB27CECF57F43C2E49@MW2PR12MB2570.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BzNiFHQ5pNudar6xpQbAdLeY2h8Jzx3vzPrfdpmNt1v4N4R+nAWVgnJWwUcSciXsMsa+1IBzi6AARBkRreaNzgnIL74e/+yxckYXWjtGKDjfxr9lI6EPIUOU51gyJfCyxGrdkBQ5S+nzmjvmiQhJ8wip/VD2W7PPr/qyRMDQJ0BkY7SF8Wo9ebdWwVonP+RlwHbsR7yLfqGAArvsx+2puVyWml0TRc/3lDg53YIivV0sIvcUYw8sLDbs11b5In/Zl25XIbDxW5qTAxhUSBPITZOLadEltHgnUd4GNONLA/6E/2hK0SFgjAlpF4rq/Huvnx0igbUfx7OsY1CL2VY3/+4HUpiPTIWJCRNydSYam9/uCYKITQtEREGA63oO0Y284h0FjBQXhERC22m7TIlN3gjExplbrc43AlkjMGi2LDEM4jmxkZfp4TKieZqAf5cmR2Zc5sJDayyIFC4yaC/KFcutKY0zL+4hrJqDi++USSYsVdY1ZTQROeQGQDQe8ZAUinHhLiR7JQiEl+Ua3GoB1W4cvB+do1pyXgVETjDZwmFgDqgzEIuNC176yL+2P4GULx8SKVBw463UroaaVkOaD8y8VumIXFBPvyporeNW0lxO9v8L9JapA4yVRYRrbfXjvnEbZZcXqtdqjlwsKvyS0OQMlrs9uaZVstPpDAaGsEIf82MQyuOVkfGY5mBYBfSCy4mo50WsIWIi2AHaA+aH30EPTpVLd2SLqYkryN46L9vSmr36PGuLzyquEqh9nORHfHEgwg7NGCFcBi+HugNFM9tM7dqy0+ykW46pugX1GyuVyzXfDVao1zLrzhIW/qgKUQmtSTQHD7Rphv89eRrJMeezEh4sLgf+gZZZ2Zisrrs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3823.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(4326008)(66476007)(66556008)(21480400003)(53546011)(36756003)(8676002)(66946007)(83380400001)(86362001)(2906002)(2616005)(235185007)(110136005)(316002)(33656002)(5660300002)(38100700002)(30864003)(8936002)(966005)(6486002)(186003)(26005)(508600001)(6506007)(6512007)(45980500001)(72826004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Rj2IQkqPrm7wSz1CdDbB1k1P7DBILTPJfEbL1qMQpi5jEzbsm4Avxomuz7Vv?=
 =?us-ascii?Q?5Be724hvQzzHfEzgHKI+g7dQffkRGlssvwzxjAT2eGKysQ8cFKS8Rl5G2ELa?=
 =?us-ascii?Q?5l6fLHE/lQGNPciFr67eKYDaDN1M+jGSQBgrRKd3UZJJpG7IiVpf1sdnqUfn?=
 =?us-ascii?Q?q/FhrJm3FZanbrl9uBlmvEwCTR1WjJwFroGVW31gX31OtSmPDX2M1p0QJ1ys?=
 =?us-ascii?Q?kUASjYVrv+bt3f7GHE1IKcvYPJYApIkXYlDPUGp6ymgEYnsZkNkcyIFfWIzT?=
 =?us-ascii?Q?1IfDDXN+dyE/gQTnQ85m6LiGvbML6KCsf29JCixOllU439SDRCtK+NxWK1Bm?=
 =?us-ascii?Q?44oBIK/bxbxg8b/W+ldP55zVnU4qW/1kE1QrPWfKGn+Oktv1eE1mpY7QKERs?=
 =?us-ascii?Q?lfTAAm3HmUWoZMj+bvk6P6miqRVqEiXztsQs1ySj7vlzmGjTtEoWhLSZ9HUr?=
 =?us-ascii?Q?q82Q03Mmjy6gsJ8FEiJZc772raoQppVRm/W24S/oE+igB1VwSoSeajEL+U9E?=
 =?us-ascii?Q?OMSlSIi9slbQRjmhV3l3FbqCX9DMMJPoFZNcKGPK6+6gQW8/KcBqla8T7etV?=
 =?us-ascii?Q?PUVmTCQuRFo3x1GC3Pufc+9twiv6fTKXfU82F8gBZC80tyhUpPTSs1J6OAF6?=
 =?us-ascii?Q?uGhvlLAwAPHQPzQQgetjUtFRzSERqk/eJ63TMezWiLLg6iqFSsFtVdG/fR9t?=
 =?us-ascii?Q?cETrxwmIv4FSsft10JvGJd4JU51OuBH7HpFREFN1SEc86ZaTVlhiFNgUXMKu?=
 =?us-ascii?Q?LYH6GP16L2ssyo+MoqzcRQYimM1+UsnmALlMKGWvwtN8DdiIjcpH2N+jwvFq?=
 =?us-ascii?Q?AbeheiG8kZTtTkJ4nY/9sGZQQ6XWx5TcEex3Jk4eUAz5zFCtoHUlGHwNf7c1?=
 =?us-ascii?Q?+ZNT9K6aPEXF8Cr3K13v1icJ0J013edbeJ16O9McI8vwp39rzFE4b3xTlHP4?=
 =?us-ascii?Q?9i/m6mf6CROvmCGfbhdlgljp0UvdYXxEz3CsowsAUWvQ8GGc8sD1k9BV0Ub0?=
 =?us-ascii?Q?Tt+kedD5BXf5j+rBuk2NKDrhHbkGL5yINzSw3WUGvWYRIbUU/YFhzFuE4XAU?=
 =?us-ascii?Q?ktPWGxvEewAnRnPagLzN3qQjSkQu1bVlvjxrhESHc29wegAAm+hBWKnTxv+V?=
 =?us-ascii?Q?ImzawOtroL9++VLYUn1Qk1/y0j7/YbmyOI123QY7T8iipPJ2Knu40uwE/Ycl?=
 =?us-ascii?Q?LvEKsub/BmaN0oE/F8kAXOZZ0lb+qfIX9JxyXkQ5YG5G1mH3/PziANjF6aS8?=
 =?us-ascii?Q?5z3kSuKVVnn8UL5EQLVGbH8P5LsJBHYnX2uhBSw73sSjFoW0L1Cqa7l1QJ/S?=
 =?us-ascii?Q?AeEGXNsLQnhkuqw437GUSd4gObBW76dtRxhLs8WTdlqdurgmn7FOb9lanero?=
 =?us-ascii?Q?fLxeYRB/RlWWkpQpqHUDbKXQOg2GCa065k529ZanxRaB7bFNMkwikUpPwqTI?=
 =?us-ascii?Q?opg22xpAcrtImUbfGtIrabyZw8yzM+7dZy5zl4sH9Ff+wgA38VjxUMFMAz4M?=
 =?us-ascii?Q?Vu93vO1VGhxsQOa0rj9dMeqeQ/ZhJ9NJbguhAIa7KN68ZdTcs+Rpq3HEsjcV?=
 =?us-ascii?Q?+Rz5MiwM6SEWfqCGOMf9F5HaLTgKTlAIHY1hsgq8pjhYPJGMcOBw/0uqZ1CP?=
 =?us-ascii?Q?tFB2P11YZNbyiYMWPkC8+G6c6dpFSOBHJcGQ4npsFmQZ22A1Fps46oOb9ldq?=
 =?us-ascii?Q?5lHdl9wCReF/FAsjr/1Tp+PZcRWINumV3JB96ErU4TlMP67AuhMz0TUcfNOO?=
 =?us-ascii?Q?9ouDbSOkOA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42796026-06be-4779-fa94-08da17107954
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3823.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2022 14:27:55.0749
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U1A1HD9xX8xQe52YYBkm+lwcXzDP3v+0Ji6MFpGh7flKPloceKw6SdecWFAL2QiW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR12MB2570
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

--=_MailMate_F5DDAABF-3DA2-4D80-8E76-4801C2D44134_=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On 5 Apr 2022, at 7:06, David Hildenbrand wrote:

> On 05.04.22 12:52, David Hildenbrand wrote:
>> On 05.04.22 12:42, Vlastimil Babka wrote:
>>> On 4/5/22 12:29, David Hildenbrand wrote:
>>>>> +
>>>>> +/*
>>>>> + * This function checks whether a page is free && is the buddy
>>>>> + * we can coalesce a page and its buddy if
>>>>> + * (a) the buddy is not in a hole (check before calling!) &&
>>>>> + * (b) the buddy is in the buddy system &&
>>>>> + * (c) a page and its buddy have the same order &&
>>>>> + * (d) a page and its buddy are in the same zone.
>>>>> + *
>>>>> + * For recording whether a page is in the buddy system, we set Pag=
eBuddy.
>>>>> + * Setting, clearing, and testing PageBuddy is serialized by zone-=
>lock.
>>>>> + *
>>>>> + * For recording page's order, we use page_private(page).
>>>>> + */
>>>>> +static inline bool page_is_buddy(struct page *page, struct page *b=
uddy,
>>>>> +							unsigned int order)
>>>>
>>>> Nit: Strange indentation of the last parameter. But it's already in =
the
>>>> code you're moving, so ...
>>>>
>>>>> +{
>>>>> +	if (!page_is_guard(buddy) && !PageBuddy(buddy))
>>>>> +		return false;
>>>>> +
>>>>> +	if (buddy_order(buddy) !=3D order)
>>>>> +		return false;
>>>>> +
>>>>> +	/*
>>>>> +	 * zone check is done late to avoid uselessly calculating
>>>>> +	 * zone/node ids for pages that could never merge.
>>>>
>>>> I know, this is from existing code. But there really isn't a node ch=
eck
>>>> when relying on the zone id. I hope we are not missing a node check =
:)
>>>
>>> AFAIK "zone_id" is in fact the combination of node+zone (or section+z=
one),
>>> so it works as long as in config where it's a section
>>> (NODE_NOT_IN_PAGE_FLAGS is defined) then there can't be multiple node=
s in a
>>> single section.
>>
>> Oh, okay. I was reading "We are not really identifying the zone since =
we
>> could be using the section number id if we do not have node id availab=
le
>> in page flags.. We only guarantee that it will return the same value f=
or
>> two combinable pages in a zone."
>>
>> an naturally wondered if this could be problematic. Thanks for clarify=
ing.
>>
>> (once we would support MAX_ORDER-1 exceed a single memory section this=

>> could be problematic)
>
> Looking once more, I think the section check might be sufficient. I
> wasn't aware that we'll always have the NODE id stored in page->flags
> with vmemmap. (hopefully with more page->flags users like mglru that
> won't change)

Thanks for the review. All the nits are fixed below.

Hi Andrew, let me know if sending a v4 would be preferred.


=46rom 8b42444d03c105d5270c0dafc1aaa3e8c59bc7d4 Mon Sep 17 00:00:00 2001
From: Zi Yan <ziy@nvidia.com>
Date: Thu, 31 Mar 2022 18:59:10 -0400
Subject: [PATCH v4 2/2] mm: wrap __find_buddy_pfn() with a necessary budd=
y
 page validation.

Whenever the buddy of a page is found from __find_buddy_pfn(),
page_is_buddy() should be used to check its validity. Add a helper
function find_buddy_page_pfn() to find the buddy page and do the check
together.

Link: https://lkml.kernel.org/r/20220401230804.1658207-2-zi.yan@sent.com
Link: https://lore.kernel.org/linux-mm/CAHk-=3Dwji_AmYygZMTsPMdJ7XksMt7kO=
ur8oDfDdniBRMjm4VkQ@mail.gmail.com/
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Zi Yan <ziy@nvidia.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
---
 mm/internal.h       | 117 ++++++++++++++++++++++++++++++++++----------
 mm/page_alloc.c     |  52 +++-----------------
 mm/page_isolation.c |   9 ++--
 3 files changed, 101 insertions(+), 77 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 876e66237c89..6ec89b4f0bc8 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -211,6 +211,67 @@ struct alloc_context {
 	bool spread_dirty_pages;
 };

+/*
+ * This function returns the order of a free page in the buddy system. I=
n
+ * general, page_zone(page)->lock must be held by the caller to prevent =
the
+ * page from being allocated in parallel and returning garbage as the or=
der.
+ * If a caller does not hold page_zone(page)->lock, it must guarantee th=
at the
+ * page cannot be allocated or merged in parallel. Alternatively, it mus=
t
+ * handle invalid values gracefully, and use buddy_order_unsafe() below.=

+ */
+static inline unsigned int buddy_order(struct page *page)
+{
+	/* PageBuddy() must be checked by the caller */
+	return page_private(page);
+}
+
+/*
+ * Like buddy_order(), but for callers who cannot afford to hold the zon=
e lock.
+ * PageBuddy() should be checked first by the caller to minimize race wi=
ndow,
+ * and invalid values must be handled gracefully.
+ *
+ * READ_ONCE is used so that if the caller assigns the result into a loc=
al
+ * variable and e.g. tests it for valid range before using, the compiler=
 cannot
+ * decide to remove the variable and inline the page_private(page) multi=
ple
+ * times, potentially observing different values in the tests and the ac=
tual
+ * use of the result.
+ */
+#define buddy_order_unsafe(page)	READ_ONCE(page_private(page))
+
+/*
+ * This function checks whether a page is free && is the buddy
+ * we can coalesce a page and its buddy if
+ * (a) the buddy is not in a hole (check before calling!) &&
+ * (b) the buddy is in the buddy system &&
+ * (c) a page and its buddy have the same order &&
+ * (d) a page and its buddy are in the same zone.
+ *
+ * For recording whether a page is in the buddy system, we set PageBuddy=
=2E
+ * Setting, clearing, and testing PageBuddy is serialized by zone->lock.=

+ *
+ * For recording page's order, we use page_private(page).
+ */
+static inline bool page_is_buddy(struct page *page, struct page *buddy,
+				 unsigned int order)
+{
+	if (!page_is_guard(buddy) && !PageBuddy(buddy))
+		return false;
+
+	if (buddy_order(buddy) !=3D order)
+		return false;
+
+	/*
+	 * zone check is done late to avoid uselessly calculating
+	 * zone/node ids for pages that could never merge.
+	 */
+	if (page_zone_id(page) !=3D page_zone_id(buddy))
+		return false;
+
+	VM_BUG_ON_PAGE(page_count(buddy) !=3D 0, buddy);
+
+	return true;
+}
+
 /*
  * Locate the struct page for both the matching buddy in our
  * pair (buddy1) and the combined O(n+1) page they form (page).
@@ -234,6 +295,35 @@ __find_buddy_pfn(unsigned long page_pfn, unsigned in=
t order)
 	return page_pfn ^ (1 << order);
 }

+/*
+ * Find the buddy of @page and validate it.
+ * @page: The input page
+ * @pfn: The pfn of the page, it saves a call to page_to_pfn() when the
+ *       function is used in the performance-critical __free_one_page().=

+ * @order: The order of the page
+ * @buddy_pfn: The output pointer to the buddy pfn, it also saves a call=
 to
+ *             page_to_pfn().
+ *
+ * The found buddy can be a non PageBuddy, out of @page's zone, or its o=
rder is
+ * not the same as @page. The validation is necessary before use it.
+ *
+ * Return: the found buddy page or NULL if not found.
+ */
+static inline struct page *find_buddy_page_pfn(struct page *page,
+			unsigned long pfn, unsigned int order, unsigned long *buddy_pfn)
+{
+	unsigned long __buddy_pfn =3D __find_buddy_pfn(pfn, order);
+	struct page *buddy;
+
+	buddy =3D page + (__buddy_pfn - pfn);
+	if (buddy_pfn)
+		*buddy_pfn =3D __buddy_pfn;
+
+	if (page_is_buddy(page, buddy, order))
+		return buddy;
+	return NULL;
+}
+
 extern struct page *__pageblock_pfn_to_page(unsigned long start_pfn,
 				unsigned long end_pfn, struct zone *zone);

@@ -336,33 +426,6 @@ isolate_migratepages_range(struct compact_control *c=
c,
 int find_suitable_fallback(struct free_area *area, unsigned int order,
 			int migratetype, bool only_stealable, bool *can_steal);

-/*
- * This function returns the order of a free page in the buddy system. I=
n
- * general, page_zone(page)->lock must be held by the caller to prevent =
the
- * page from being allocated in parallel and returning garbage as the or=
der.
- * If a caller does not hold page_zone(page)->lock, it must guarantee th=
at the
- * page cannot be allocated or merged in parallel. Alternatively, it mus=
t
- * handle invalid values gracefully, and use buddy_order_unsafe() below.=

- */
-static inline unsigned int buddy_order(struct page *page)
-{
-	/* PageBuddy() must be checked by the caller */
-	return page_private(page);
-}
-
-/*
- * Like buddy_order(), but for callers who cannot afford to hold the zon=
e lock.
- * PageBuddy() should be checked first by the caller to minimize race wi=
ndow,
- * and invalid values must be handled gracefully.
- *
- * READ_ONCE is used so that if the caller assigns the result into a loc=
al
- * variable and e.g. tests it for valid range before using, the compiler=
 cannot
- * decide to remove the variable and inline the page_private(page) multi=
ple
- * times, potentially observing different values in the tests and the ac=
tual
- * use of the result.
- */
-#define buddy_order_unsafe(page)	READ_ONCE(page_private(page))
-
 /*
  * These three helpers classifies VMAs for virtual memory accounting.
  */
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 2ea106146686..f199931784e4 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -868,40 +868,6 @@ static inline void set_buddy_order(struct page *page=
, unsigned int order)
 	__SetPageBuddy(page);
 }

-/*
- * This function checks whether a page is free && is the buddy
- * we can coalesce a page and its buddy if
- * (a) the buddy is not in a hole (check before calling!) &&
- * (b) the buddy is in the buddy system &&
- * (c) a page and its buddy have the same order &&
- * (d) a page and its buddy are in the same zone.
- *
- * For recording whether a page is in the buddy system, we set PageBuddy=
=2E
- * Setting, clearing, and testing PageBuddy is serialized by zone->lock.=

- *
- * For recording page's order, we use page_private(page).
- */
-static inline bool page_is_buddy(struct page *page, struct page *buddy,
-							unsigned int order)
-{
-	if (!page_is_guard(buddy) && !PageBuddy(buddy))
-		return false;
-
-	if (buddy_order(buddy) !=3D order)
-		return false;
-
-	/*
-	 * zone check is done late to avoid uselessly calculating
-	 * zone/node ids for pages that could never merge.
-	 */
-	if (page_zone_id(page) !=3D page_zone_id(buddy))
-		return false;
-
-	VM_BUG_ON_PAGE(page_count(buddy) !=3D 0, buddy);
-
-	return true;
-}
-
 #ifdef CONFIG_COMPACTION
 static inline struct capture_control *task_capc(struct zone *zone)
 {
@@ -1010,18 +976,17 @@ static inline bool
 buddy_merge_likely(unsigned long pfn, unsigned long buddy_pfn,
 		   struct page *page, unsigned int order)
 {
-	struct page *higher_page, *higher_buddy;
-	unsigned long combined_pfn;
+	unsigned long higher_page_pfn;
+	struct page *higher_page;

 	if (order >=3D MAX_ORDER - 2)
 		return false;

-	combined_pfn =3D buddy_pfn & pfn;
-	higher_page =3D page + (combined_pfn - pfn);
-	buddy_pfn =3D __find_buddy_pfn(combined_pfn, order + 1);
-	higher_buddy =3D higher_page + (buddy_pfn - combined_pfn);
+	higher_page_pfn =3D buddy_pfn & pfn;
+	higher_page =3D page + (higher_page_pfn - pfn);

-	return page_is_buddy(higher_page, higher_buddy, order + 1);
+	return find_buddy_page_pfn(higher_page, higher_page_pfn, order + 1,
+			NULL) !=3D NULL;
 }

 /*
@@ -1075,10 +1040,9 @@ static inline void __free_one_page(struct page *pa=
ge,
 								migratetype);
 			return;
 		}
-		buddy_pfn =3D __find_buddy_pfn(pfn, order);
-		buddy =3D page + (buddy_pfn - pfn);

-		if (!page_is_buddy(page, buddy, order))
+		buddy =3D find_buddy_page_pfn(page, pfn, order, &buddy_pfn);
+		if (!buddy)
 			goto done_merging;

 		if (unlikely(order >=3D pageblock_order)) {
diff --git a/mm/page_isolation.c b/mm/page_isolation.c
index f67c4c70f17f..ff0ea6308299 100644
--- a/mm/page_isolation.c
+++ b/mm/page_isolation.c
@@ -70,7 +70,6 @@ static void unset_migratetype_isolate(struct page *page=
, unsigned migratetype)
 	unsigned long flags, nr_pages;
 	bool isolated_page =3D false;
 	unsigned int order;
-	unsigned long pfn, buddy_pfn;
 	struct page *buddy;

 	zone =3D page_zone(page);
@@ -89,11 +88,9 @@ static void unset_migratetype_isolate(struct page *pag=
e, unsigned migratetype)
 	if (PageBuddy(page)) {
 		order =3D buddy_order(page);
 		if (order >=3D pageblock_order && order < MAX_ORDER - 1) {
-			pfn =3D page_to_pfn(page);
-			buddy_pfn =3D __find_buddy_pfn(pfn, order);
-			buddy =3D page + (buddy_pfn - pfn);
-
-			if (!is_migrate_isolate_page(buddy)) {
+			buddy =3D find_buddy_page_pfn(page, page_to_pfn(page),
+						    order, NULL);
+			if (buddy && !is_migrate_isolate_page(buddy)) {
 				isolated_page =3D !!__isolate_free_page(page, order);
 				/*
 				 * Isolating a free page in an isolated pageblock
-- =

2.35.1


--
Best Regards,
Yan, Zi

--=_MailMate_F5DDAABF-3DA2-4D80-8E76-4801C2D44134_=
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJDBAEBCgAtFiEEh7yFAW3gwjwQ4C9anbJR82th+ooFAmJMUekPHHppeUBudmlk
aWEuY29tAAoJEJ2yUfNrYfqKk/QQAK8QIaZDtbCGz8hY9JUsESr6pPC4ExTd2K8H
ganCgISJPNAD4uyL+ZQ2xKEZ2kDz3TJyUnMiaAUJgS101VDItli/8aaS2SYD9aYp
Fhc/mZTiNquNy/Ll4XsTZQM38lkWz21ng6MSRQYpW7kyMJzuZfObnxUs2nzaDPKq
cYsWEUpU1mIdhIMjtPJLcm5ITG5Jx/EKGeT1GqsdxeGZTDO8M99lkMiChHj8hfsN
+ymZ8+UFF+9bu1GKD5XQRYW092IMa6u+65ijGLnRL+Lr/HKr0Gq7ciBSWvUEZOkC
MFQzCTmKGMPbo6MmCPpoNxHirq3mlOS3/Du9xVOkzekPeZVqDXWiQILCRG9+9M4y
tNtyq0Z8XoFONZ6CQoVADqaYhRUB41Fs3k1IQuLXkOert0JiSKAO+0XktzyaPwjr
V5TDIZvoe1RI2emQVfPZMvEgO1+x52iBxXQqgLKCBXUCMgY0Dy23uCRttBh8kSQn
c6pecbZJh4cf6LvrRsIKsMGSMO7SkknAlRtiUF5yoP5UvJG0ZUEKEG8NvEKZZmUp
I8t6pzS8aw1OX6DNevo6WTo+uCK9cFGv40CRhV8f545uiHmlUIDUXSVc/fJxayBL
vaQzkNSkSmDa6xK1S/njzRDelElTmfOKL5kZUQJq7bICsO61PjPkEHyaCx33Ze3e
sSdPtbXI
=tRgL
-----END PGP SIGNATURE-----

--=_MailMate_F5DDAABF-3DA2-4D80-8E76-4801C2D44134_=--
